/***************************************************************************
 *   Copyright © 2013 Aleix Pol Gonzalez <aleixpol@blue-systems.com>       *
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

#include "DummyBackend.h"
#include "DummyResource.h"
#include "DummyReviewsBackend.h"
#include "DummyTransaction.h"
#include <resources/StandardBackendUpdater.h>
#include <Transaction/Transaction.h>
#include <Transaction/TransactionModel.h>

#include <KAboutData>
#include <KLocalizedString>
#include <KPluginFactory>
#include <QDebug>
#include <QThread>
#include <QTimer>
#include <QAction>

K_PLUGIN_FACTORY(MuonDummyBackendFactory, registerPlugin<DummyBackend>(); )
K_EXPORT_PLUGIN(MuonDummyBackendFactory(KAboutData("muon-dummybackend","muon-dummybackend",ki18n("Dummy Backend"),"0.1",ki18n("Dummy backend to test muon frontends"), KAboutData::License_GPL)))

DummyBackend::DummyBackend(QObject* parent, const QVariantList&)
    : AbstractResourcesBackend(parent)
    , m_updater(new StandardBackendUpdater(this))
    , m_fetching(false)
{
    for(int i=0; i<32000; i++) {
        QString name = "alalala"+QString::number(i);
        DummyResource* res = new DummyResource(name, this);
        res->setState(AbstractResource::State(1+(i%3)));
        m_resources.insert(name, res);
        connect(res, SIGNAL(stateChanged()), SIGNAL(updatesCountChanged()));
    }

    m_reviews = new DummyReviewsBackend(this);

    QAction* updateAction = new QAction(this);
    updateAction->setIcon(QIcon::fromTheme("system-software-update"));
    updateAction->setText(i18nc("@action Checks the Internet for updates", "Check for Updates"));
    updateAction->setShortcut(QKeySequence(Qt::CTRL + Qt::Key_R));
    connect(updateAction, SIGNAL(triggered()), SLOT(checkForUpdates()));
    m_updater->setMessageActions(QList<QAction*>() << updateAction);
}

void DummyBackend::toggleFetching()
{
    m_fetching = !m_fetching;
    qDebug() << "fetching..." << m_fetching;
    emit fetchingChanged();
}

QVector<AbstractResource*> DummyBackend::allResources() const
{
    Q_ASSERT(!m_fetching);
    QVector<AbstractResource*> ret;
    ret.reserve(m_resources.size());
    foreach(AbstractResource* res, m_resources) {
        ret += res;
    }
    return ret;
}

int DummyBackend::updatesCount() const
{
    return upgradeablePackages().count();
}

QList<AbstractResource*> DummyBackend::upgradeablePackages() const
{
    QList<AbstractResource*> updates;
    foreach(AbstractResource* res, m_resources) {
        if(res->state()==AbstractResource::Upgradeable)
            updates += res;
    }
    return updates;
}

AbstractResource* DummyBackend::resourceByPackageName(const QString& name) const
{
    return m_resources.value(name);
}

QList<AbstractResource*> DummyBackend::searchPackageName(const QString& searchText)
{
    QList<AbstractResource*> ret;
    foreach(AbstractResource* r, m_resources) {
        if(r->name().contains(searchText, Qt::CaseInsensitive) || r->comment().contains(searchText, Qt::CaseInsensitive))
            ret += r;
    }
    return ret;
}

AbstractBackendUpdater* DummyBackend::backendUpdater() const
{
    return m_updater;
}

AbstractReviewsBackend* DummyBackend::reviewsBackend() const
{
    return m_reviews;
}

void DummyBackend::installApplication(AbstractResource* app, AddonList )
{
    installApplication(app);
}

void DummyBackend::installApplication(AbstractResource* app)
{
	TransactionModel *transModel = TransactionModel::global();
	transModel->addTransaction(new DummyTransaction(qobject_cast<DummyResource*>(app), Transaction::InstallRole));
}

void DummyBackend::removeApplication(AbstractResource* app)
{
	TransactionModel *transModel = TransactionModel::global();
	transModel->addTransaction(new DummyTransaction(qobject_cast<DummyResource*>(app), Transaction::RemoveRole));
}

void DummyBackend::cancelTransaction(AbstractResource*)
{}

void DummyBackend::checkForUpdates()
{
    if(m_fetching)
        return;
    toggleFetching();
    QTimer::singleShot(2000, this, SLOT(toggleFetching()));
}

#include "DummyBackend.moc"
