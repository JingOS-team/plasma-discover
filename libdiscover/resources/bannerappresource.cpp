/*
 *   SPDX-FileCopyrightText:      2021 Zhang He Gang <zhanghegang@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include "bannerappresource.h"
#include "network/HttpClient.h"

BannerAppResource::BannerAppResource(QString appName,QString bannerUrl,bool isRefresh)
    : m_appName(appName)
    , m_isRefresh(isRefresh)
{
    setBannerUrl(bannerUrl,appName);
}

void BannerAppResource::setAppName(QString appName) {
    if (m_appName != appName) {
        emit appNameChanged();
    }
}

QString BannerAppResource::bannerUrl()
{
    return m_bannerUrl;
}

void BannerAppResource::setBannerUrl(QString bannerUrl, QString cacheFileName) {
    QStringList strData = bannerUrl.split("/");
    if (strData.size() > 1) {
        QString cacheFileName = strData[strData.size() - 1];
        const QString fileName = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + "/banners/"+ cacheFileName;
        qDebug()<< Q_FUNC_INFO << " cacheFileName:" << fileName << " QFileInfo::exists(fileName):" << QFileInfo::exists(fileName);
        if (!QFileInfo::exists(fileName)) {
            const QDir cacheDir(QStandardPaths::writableLocation(QStandardPaths::CacheLocation));
            // Create $HOME/.cache/discover/banners folder
            cacheDir.mkdir(QStringLiteral("banners"));
            QNetworkAccessManager *manager = new QNetworkAccessManager(this);
            connect(manager, &QNetworkAccessManager::finished, this, [this, fileName, manager] (QNetworkReply *reply) {
                if (reply->error() == QNetworkReply::NoError) {
                    QByteArray iconData = reply->readAll();
                    QFile file(fileName);
                    if (file.open(QIODevice::WriteOnly)) {
                        file.write(iconData);
                    }
                    file.close();
                    QFileInfo bannerFileInfo(file);
                    m_bannerUrl = "file://" +bannerFileInfo.absoluteFilePath();
                    qDebug()<< Q_FUNC_INFO << " m_bannerUrl:" << m_bannerUrl;
                    Q_EMIT bannerUrlChanged();
                }
                manager->deleteLater();
            });
            QUrl bu(bannerUrl);
            manager->get(QNetworkRequest(bu));
        } else {
            m_bannerUrl = "file://" + fileName;
            emit bannerUrlChanged();
        }
    } else {
        m_bannerUrl = bannerUrl;
        emit bannerUrlChanged();
    }
}
