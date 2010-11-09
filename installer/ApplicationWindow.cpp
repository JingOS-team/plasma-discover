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

#include "ApplicationWindow.h"

// Qt includes
#include <QStandardItemModel>
#include <QtCore/QTimer>
#include <QtGui/QSplitter>
#include <KCategorizedSortFilterProxyModel>

// KDE includes
#include <KIcon>

// Own includes
#include "CategoryView.h"
#include "OriginView.h"
#include "ApplicationModel/ApplicationView.h"

ApplicationWindow::ApplicationWindow()
    : MuonMainWindow()
    , m_powerInhibitor(0)
{
    initGUI();
    QTimer::singleShot(10, this, SLOT(initObject()));
}

ApplicationWindow::~ApplicationWindow()
{
}

void ApplicationWindow::initGUI()
{
    setWindowTitle(i18n("Muon Software Center"));

    m_mainWidget = new QSplitter(this);
    m_mainWidget->setOrientation(Qt::Horizontal);
    connect(m_mainWidget, SIGNAL(splitterMoved(int, int)), this, SLOT(saveSplitterSizes()));
    setCentralWidget(m_mainWidget);

    m_categoryView = new CategoryView(this);
    m_mainWidget->addWidget(m_categoryView);

    OriginView *originView = new OriginView(this);
    connect(this, SIGNAL(backendReady(QApt::Backend *)),
            originView, SLOT(setBackend(QApt::Backend *)));
//     connect(originView, SIGNAL(activated(const QModelIndex &)),
//            m_mainView, SIGNAL(changeView(const QModelIndex &)));
    m_mainWidget->addWidget(originView);

    m_appView = new ApplicationView(this);
    m_mainWidget->addWidget(m_appView);

    connect(this, SIGNAL(backendReady(QApt::Backend *)),
            m_appView, SLOT(setBackend(QApt::Backend *)));
    connect(this, SIGNAL(backendReady(QApt::Backend *)),
            this, SLOT(reload()));
}

void ApplicationWindow::reload()
{
    QStandardItemModel *categoryModel = new QStandardItemModel(this);
    QStandardItem *categoryItem = new QStandardItem;
    categoryItem->setText(i18n("Internet"));
    categoryItem->setIcon(KIcon("applications-internet"));
    categoryItem->setData(i18n("Groups"), KCategorizedSortFilterProxyModel::CategoryDisplayRole);
    categoryModel->appendRow(categoryItem);

    KCategorizedSortFilterProxyModel *proxy = new KCategorizedSortFilterProxyModel(this);
    proxy->setSourceModel(categoryModel);
    proxy->setCategorizedModel(true);
    proxy->sort(0);
    m_categoryView->setModel(proxy);
}

#include "ApplicationWindow.moc"
