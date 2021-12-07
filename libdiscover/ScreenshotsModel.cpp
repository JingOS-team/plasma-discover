/*
 *   SPDX-FileCopyrightText: 2012 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *                           2021 Zhang He Gang <zhanghegang@jingos.com>
 *   SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "ScreenshotsModel.h"
#include <resources/AbstractResource.h>
#include "libdiscover_debug.h"
// #include <QAbstractItemModelTester>


ScreenshotsModel::ScreenshotsModel(QObject* parent)
    : QAbstractListModel(parent)
    , m_resource(nullptr)
{
    connect(this,&ScreenshotsModel::cacheEndChanged,this, &ScreenshotsModel::onCacheEnd);
}

QHash< int, QByteArray > ScreenshotsModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractItemModel::roleNames();
    roles.insert(ThumbnailUrl, "small_image_url");
    roles.insert(ScreenshotUrl, "large_image_url");
    return roles;
}

void ScreenshotsModel::setResource(AbstractResource* res)
{

    if (res == m_resource)
        return;

    if (m_resource) {
        disconnect(m_resource, &AbstractResource::screenshotsFetched, this, &ScreenshotsModel::screenshotsFetched);
    }
    m_resource = res;
    Q_EMIT resourceChanged(res);

    if (res) {
        connect(m_resource, &AbstractResource::screenshotsFetched, this, &ScreenshotsModel::screenshotsFetched);
        res->fetchScreenshots();
    } else
        qCWarning(LIBDISCOVER_LOG) << "empty resource!";
}

AbstractResource* ScreenshotsModel::resource() const
{
    return m_resource;
}

void ScreenshotsModel::screenshotsFetched(const QList< QUrl >& thumbnails, const QList< QUrl >& screenshots)
{
    Q_ASSERT(thumbnails.count()==screenshots.count());
    if (thumbnails.isEmpty())
        return;
    m_thumberNumber = thumbnails.size();
//    beginInsertRows(QModelIndex(), m_thumbnails.size(), m_thumbnails.size()+thumbnails.size()-1);
    m_screenshots.clear();
    m_thumbnails.clear();
    cacheLoaclScreents(thumbnails);
    m_screenshots += screenshots;
//    endInsertRows();
    emit countChanged();
}

QList<QUrl> ScreenshotsModel::cacheLoaclScreents(QList<QUrl> thumbnails)
{
    m_loadCacheNumber = 0;
    foreach(QUrl thumbUrl , thumbnails){
        QString urlString = thumbUrl.url();
        if(urlString == ""){
           continue;
        }
        qDebug()<< Q_FUNC_INFO << " thumbUrl.url():" << urlString;
        QStringList strData = urlString.split("/");
        if (strData.size() > 1) {
            QString cacheFileName = strData[strData.size() - 1];
            const QString fileName = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + "/screenshots/"+ cacheFileName;
            qDebug()<< Q_FUNC_INFO << " cacheFileName:" << fileName << " QFileInfo::exists(fileName):" << QFileInfo::exists(fileName);
            if (!QFileInfo::exists(fileName)) {
                const QDir cacheDir(QStandardPaths::writableLocation(QStandardPaths::CacheLocation));
                // Create $HOME/.cache/discover/screenshots folder
                cacheDir.mkdir(QStringLiteral("screenshots"));
                QNetworkAccessManager *manager = new QNetworkAccessManager(this);
                connect(manager, &QNetworkAccessManager::finished, this, [this, fileName, manager] (QNetworkReply *reply) {
                    qDebug()<< Q_FUNC_INFO << "******** reply->error():" << reply->error();

                    if (reply->error() == QNetworkReply::NoError) {
                        QByteArray iconData = reply->readAll();
                        QFile file(fileName);
                        if (file.open(QIODevice::WriteOnly)) {
                            file.write(iconData);
                        }
                        file.close();
                        QFileInfo bannerFileInfo(file);
                       QString  thumbFile = "file://" +bannerFileInfo.absoluteFilePath();
                        qDebug()<< Q_FUNC_INFO << " thumbFile:" << thumbFile;
                        m_thumbnails.append(QUrl(thumbFile));
                    } else {
                        m_thumbnails.append(QUrl(""));
                    }
                    Q_EMIT cacheEndChanged();
                    manager->deleteLater();
                });
                manager->get(QNetworkRequest(thumbUrl));
            } else {
                QUrl cacheFileUrl("file://" + fileName);
                m_thumbnails.append(cacheFileUrl);
                Q_EMIT cacheEndChanged();
            }
        } else {
           m_thumbnails.append(thumbUrl);
           Q_EMIT cacheEndChanged();
        }
    }
    return m_thumbnails;
}

void ScreenshotsModel::onCacheEnd()
{
    m_loadCacheNumber ++;
    if(m_loadCacheNumber == m_thumberNumber){
        beginResetModel();
        endResetModel();
    }
}

QVariant ScreenshotsModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.parent().isValid())
        return QVariant();

    switch (role) {
    case ThumbnailUrl:
    {
        if (m_thumbnails.size() <= 0 || index.row() >= m_thumbnails.size()) {
            return "";
        }
        QUrl turl = m_thumbnails[index.row()];
        if(turl.isValid()){
            return turl;
        }
        return QVariant();
    }
    case ScreenshotUrl:
    {
        if (m_screenshots.size() <= 0 || index.row() >= m_screenshots.size()) {
            return "";
        }
        QUrl url = m_screenshots[index.row()];
        if(url.isValid()){
            return url;
        }
        return QVariant();
    }
    }

    return QVariant();
}

int ScreenshotsModel::rowCount(const QModelIndex& parent) const
{
    return !parent.isValid() ? m_screenshots.count() : 0;
}

QUrl ScreenshotsModel::screenshotAt(int row) const
{
    return m_screenshots[row];
}

int ScreenshotsModel::count() const
{
    auto count = m_screenshots.count();
    return count;
}

void ScreenshotsModel::remove(const QUrl& url)
{
    int idxRemove = m_thumbnails.indexOf(url);
    if (idxRemove>=0) {
        beginRemoveRows({}, idxRemove, idxRemove);
        m_thumbnails.removeAt(idxRemove);
        m_screenshots.removeAt(idxRemove);
        endRemoveRows();
        emit countChanged();

        qDebug() << "screenshot removed" << url;
    }
}
