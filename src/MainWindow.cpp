/***************************************************************************
 *   Copyright © 2010 Jonathan Thomas <echidnaman@kubuntu.org>             *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or         *
 *   modify it under the terms of the GNU General Public License as        *
 *   published by the Free Software Foundation; either version 2 of        *
 *   the License or (at your option) version 3 or any later version        *
 *   accepted by the membership of KDE e.V. (or its successor approved     *
 *   by the membership of KDE e.V.), which shall act as a proxy            *
 *   defined in Section 14 of version 3 of the license.                    *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>. *
 ***************************************************************************/

#include "MainWindow.h"

// Qt includes
#include <QtCore/QTimer>
#include <QtGui/QLabel>
#include <QtGui/QSplitter>
#include <QtGui/QStackedWidget>
#include <QtGui/QToolBox>

// KDE includes
#include <KAction>
#include <KActionCollection>
#include <KApplication>
#include <KConfigDialog>
#include <KLocale>
#include <KMessageBox>
#include <KStandardAction>
#include <KStatusBar>
#include <KToolBar>
#include <KDebug>

// LibQApt includes
#include <libqapt/backend.h>

// Own includes
#include "CommitWidget.h"
#include "DownloadWidget.h"
#include "FilterWidget.h"
#include "ManagerWidget.h"
#include "ReviewWidget.h"
#include "StatusWidget.h"

MainWindow::MainWindow()
    : KXmlGuiWindow(0)
    , m_backend(0)
    , m_stack(0)
    , m_reviewWidget(0)
    , m_downloadWidget(0)
    , m_commitWidget(0)

{
    initGUI();
    QTimer::singleShot(10, this, SLOT(initObject()));
}

MainWindow::~MainWindow()
{
}

void MainWindow::initGUI()
{
    m_stack = new QStackedWidget;
    setCentralWidget(m_stack);

    m_managerWidget = new ManagerWidget(m_stack);
    connect (this, SIGNAL(backendReady(QApt::Backend*)),
             m_managerWidget, SLOT(setBackend(QApt::Backend*)));

    m_mainWidget = new QSplitter(this);
    m_mainWidget->setOrientation(Qt::Horizontal);

    m_filterBox = new FilterWidget(m_stack);
    connect (this, SIGNAL(backendReady(QApt::Backend*)),
             m_filterBox, SLOT(setBackend(QApt::Backend*)));
    connect (m_filterBox, SIGNAL(filterByGroup(const QString&)),
             m_managerWidget, SLOT(filterByGroup(const QString&)));
    connect (m_filterBox, SIGNAL(filterByStatus(const QString&)),
             m_managerWidget, SLOT(filterByStatus(const QString&)));

    m_mainWidget->addWidget(m_filterBox);
    m_mainWidget->addWidget(m_managerWidget);
    // TODO: Store/restore on app exit/restore
    QList<int> sizes;
    sizes << 115 << (this->width() - 115);
    m_mainWidget->setSizes(sizes);

    m_stack->addWidget(m_mainWidget);
    m_stack->setCurrentWidget(m_mainWidget);

    setupActions();

    m_statusWidget = new StatusWidget(this);
    connect (this, SIGNAL(backendReady(QApt::Backend*)),
             m_statusWidget, SLOT(setBackend(QApt::Backend*)));
    statusBar()->addWidget(m_statusWidget);
    statusBar()->show();
}

void MainWindow::initObject()
{
    m_backend = new QApt::Backend;
    m_backend->init();
    connect(m_backend, SIGNAL(workerEvent(QApt::WorkerEvent)),
            this, SLOT(workerEvent(QApt::WorkerEvent)));
    connect(m_backend, SIGNAL(errorOccurred(QApt::ErrorCode, const QVariantMap&)),
            this, SLOT(errorOccurred(QApt::ErrorCode, const QVariantMap&)));
    connect(m_backend, SIGNAL(questionOccurred(QApt::WorkerQuestion, const QVariantMap&)),
            this, SLOT(questionOccurred(QApt::WorkerQuestion, const QVariantMap&)));
    connect(m_backend, SIGNAL(packageChanged()), this, SLOT(reloadActions()));

    reloadActions(); //Get initial enabled/disabled state

    m_managerWidget->setFocus();

    emit backendReady(m_backend);
}

void MainWindow::setupActions()
{
    // local - Destroys all sub-windows and exits
    KAction *quitAction = KStandardAction::quit(this, SLOT(slotQuit()), actionCollection());
    actionCollection()->addAction("quit", quitAction);

    m_updateAction = actionCollection()->addAction("update");
    m_updateAction->setIcon(KIcon("system-software-update"));
    m_updateAction->setText(i18n("Check for Updates"));
    connect(m_updateAction, SIGNAL(triggered()), this, SLOT(checkForUpdates()));

    m_upgradeAction = actionCollection()->addAction("upgrade");
    m_upgradeAction->setIcon(KIcon("go-top"));
    m_upgradeAction->setText(i18n("Upgrade"));
    connect(m_upgradeAction, SIGNAL(triggered()), this, SLOT(markUpgrades()));

    m_previewAction = actionCollection()->addAction("preview");
    m_previewAction->setIcon(KIcon("document-preview-archive"));
    m_previewAction->setText(i18n("Preview Changes"));
    connect(m_previewAction, SIGNAL(triggered()), this, SLOT(previewChanges()));

    m_applyAction = actionCollection()->addAction("apply");
    m_applyAction->setIcon(KIcon("dialog-ok-apply"));
    m_applyAction->setText(i18n("Apply Changes"));
    connect(m_applyAction, SIGNAL(triggered()), this, SLOT(startCommit()));

    setupGUI();
}

void MainWindow::slotQuit()
{
    //Settings::self()->writeConfig();
    KApplication::instance()->quit();
}

void MainWindow::markUpgrades()
{
    m_backend->markPackagesForDistUpgrade();
    previewChanges();
}

void MainWindow::checkForUpdates()
{
    setActionsEnabled(false);
    initDownloadWidget();
    m_backend->updateCache();
}

void MainWindow::workerEvent(QApt::WorkerEvent event)
{
    switch (event) {
        case QApt::CacheUpdateStarted:
            m_downloadWidget->clear();
            m_downloadWidget->setHeaderText(i18n("<b>Updating software sources</b>"));
            m_stack->setCurrentWidget(m_downloadWidget);
            connect(m_downloadWidget, SIGNAL(cancelDownload()), m_backend, SLOT(cancelDownload()));
            break;
        case QApt::CacheUpdateFinished:
        case QApt::CommitChangesFinished:
            reload();
            returnFromPreview();
            break;
        case QApt::PackageDownloadStarted:
            m_downloadWidget->clear();
            m_downloadWidget->setHeaderText(i18n("<b>Downloading Packages</b>"));
            m_stack->setCurrentWidget(m_downloadWidget);
            connect(m_downloadWidget, SIGNAL(cancelDownload()), m_backend, SLOT(cancelDownload()));
            break;
        case QApt::CommitChangesStarted:
            m_commitWidget->clear();
            break;
        case QApt::PackageDownloadFinished:
        case QApt::InvalidEvent:
        default:
            break;
    }
}

void MainWindow::questionOccurred(QApt::WorkerQuestion code, const QVariantMap &args)
{
    QVariantMap response;

    if (code == QApt::MediaChange) {
        QString media = args["Media"].toString();
        QString drive = args["Drive"].toString();

        QString title = i18nc("@title:window", "Media Change Required");
        QString text = i18nc("@label", "Please insert %1 into %2", media, drive);

        KMessageBox::information(this, text, title);
        response["MediaChanged"] = true;
        m_backend->answerWorkerQuestion(response);
    } else if (code == QApt::InstallUntrusted) {
        QStringList untrustedItems = args["UntrustedItems"].toStringList();

        QString title = i18nc("@title:window", "Untrusted Packages");
        QString text = i18ncp("@label",
                     "The following package has not been verified by its "
                     "author. Installing unverified package represents a "
                     "security risk, as unverified packages can be a "
                     "sign of tampering. Do you wish to continue?",
                     "The following packages have not been verified by "
                     "their authors. Installing unverified packages "
                     "represents a security risk, as unverified packages "
                     "can be a sign of tampering. Do you wish to continue?",
                     untrustedItems.size());
        int result = KMessageBox::No;
        bool installUntrusted = false;

        result = KMessageBox::warningContinueCancelList(this, text,
                                                        untrustedItems, title);
        switch (result) {
            case KMessageBox::Continue:
                installUntrusted = true;
                break;
            case KMessageBox::Cancel:
                installUntrusted = false;
                break;
        }

        response["InstallUntrusted"] = installUntrusted;
        m_backend->answerWorkerQuestion(response);
    }
}

void MainWindow::previewChanges()
{
    if (!m_reviewWidget) {
        m_reviewWidget = new ReviewWidget(m_stack);
        connect (this, SIGNAL(backendReady(QApt::Backend*)),
                 m_reviewWidget, SLOT(setBackend(QApt::Backend*)));
        m_reviewWidget->setBackend(m_backend);
        m_stack->addWidget(m_reviewWidget);
    }

    m_stack->setCurrentWidget(m_reviewWidget);

    m_previewAction->setIcon(KIcon("go-previous"));
    m_previewAction->setText(i18n("Return to Package List"));
    connect(m_previewAction, SIGNAL(triggered()), this, SLOT(returnFromPreview()));
}

void MainWindow::returnFromPreview()
{
    m_stack->setCurrentWidget(m_mainWidget);

    m_previewAction->setIcon(KIcon("document-preview-archive"));
    m_previewAction->setText(i18n("Preview Changes"));
    connect(m_previewAction, SIGNAL(triggered()), this, SLOT(previewChanges()));
}

void MainWindow::startCommit()
{
    setActionsEnabled(false);
    initDownloadWidget();
    initCommitWidget();
    m_backend->commitChanges();
}

void MainWindow::initDownloadWidget()
{
    if (!m_downloadWidget) {
        m_downloadWidget = new DownloadWidget(this);
        m_stack->addWidget(m_downloadWidget);
        connect(m_backend, SIGNAL(downloadProgress(int, int, int)),
                m_downloadWidget, SLOT(updateDownloadProgress(int, int, int)));
        connect(m_backend, SIGNAL(downloadMessage(int, const QString&)),
                m_downloadWidget, SLOT(updateDownloadMessage(int, const QString&)));
    }
}

void MainWindow::initCommitWidget()
{
    if (!m_commitWidget) {
        m_commitWidget = new CommitWidget(this);
        m_stack->addWidget(m_commitWidget);
        connect(m_backend, SIGNAL(commitProgress(const QString&, int)),
                m_commitWidget, SLOT(updateCommitProgress(const QString&, int)));
    }
}

void MainWindow::reload()
{
    m_managerWidget->reload();
    if (m_reviewWidget) {
        m_reviewWidget->refresh();
    }
    m_statusWidget->updateStatus();
    setActionsEnabled(true);
    reloadActions();

    // No need to keep these around in memory.
    delete m_downloadWidget;
    delete m_commitWidget;
    m_downloadWidget = 0;
    m_commitWidget = 0;
}

void MainWindow::reloadActions()
{
    QApt::PackageList upgradeableList = m_backend->upgradeablePackages();
    QApt::PackageList changedList = m_backend->markedPackages();

    m_upgradeAction->setEnabled(!upgradeableList.isEmpty());
    m_previewAction->setEnabled(!changedList.isEmpty());
    m_applyAction->setEnabled(!changedList.isEmpty());
}

void MainWindow::setActionsEnabled(bool enabled)
{
    m_updateAction->setEnabled(enabled);
    m_upgradeAction->setEnabled(enabled);
    m_previewAction->setEnabled(enabled);
    m_applyAction->setEnabled(enabled);
}

#include "MainWindow.moc"
