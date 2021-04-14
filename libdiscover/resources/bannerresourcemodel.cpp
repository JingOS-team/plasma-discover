/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include "bannerresourcemodel.h"
#include "network/HttpClient.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QLocale>

LocalBannerThread::LocalBannerThread()
{
}

void LocalBannerThread::run() 
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QLatin1String("/bannersinfo.json");
    QFile app_json(path);
    if (app_json.open(QIODevice::ReadOnly)) {
        // 成功得到json文件
        QByteArray jsonData=app_json.readAll();
        if (!isNetworkStop && !jsonData.isEmpty()) {
            emit loadLocalSuc(jsonData,false);
            isNetworkStop = false;
        }
        app_json.close();
    }
}

void LocalBannerThread::onNetworkStop(bool isSuc)
{
    isNetworkStop = isSuc;
    if (this->isRunning()) {
        this->terminate();
    }
}

BannerResourceModel::BannerResourceModel()
{
    QString systemLan = QLocale::system().nativeLanguageName();
    if (systemLan.contains("china")) {
        currentLang = "cn";
    } else {
        currentLang = "en";
    }
    loadBannerData();
}

BannerResourceModel * BannerResourceModel::global()
{
    static BannerResourceModel *instance = nullptr;
    if (!instance) {
        instance = new BannerResourceModel;
    }
    return instance;
}

int BannerResourceModel::rowCount(const QModelIndex &parent) const
{
    return m_banners.count();
}

QHash<int, QByteArray> BannerResourceModel::roleNames() const
{
    return {{BANNER_APP,"bannerapp"}};
}

QVariant BannerResourceModel::data(const QModelIndex &index, int role) const
{
    QVariant ret;
    switch (role) {
    case BANNER_APP:
        ret = QVariant::fromValue(m_banners[index.row()]);
        break;
    }
    return ret;
}

void BannerResourceModel::loadBannerData()
{
    localThread = new LocalBannerThread();
    connect(localThread, &LocalBannerThread::loadLocalSuc,this, &BannerResourceModel::createbannerData);
    connect(this, &BannerResourceModel::networkStop,localThread, &LocalBannerThread::onNetworkStop);

    HttpClient::global() -> get(QLatin1String(BASE_URL) + QLatin1String(BANNER_URL))
    .header("content-type", "application/json")
    .queryParam("label", "banner")
    .onResponse([this](QByteArray result) {
        if (result.isEmpty()) {
            return;
        }
        emit networkStop(true);
        createbannerData(result,true);
    })
    .onError([this](QString errorStr) {
        emit networkStop(false);
        return;
    })
    .timeout(10 * 1000)
    .exec();

    localThread->start();
}

void BannerResourceModel::createbannerData(QByteArray bannerData,bool isNetworkRequest)
{
    if (isNetworkRequest) {
        QString path = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QLatin1String("/bannersinfo.json");
        QFile app_json(path);
        if (app_json.open(QIODevice::ReadWrite)) {
            QByteArray fileData =  app_json.readAll();
            if (bannerData == fileData) {
                return;
            }
            app_json.resize(0);
            app_json.write(bannerData);
            app_json.close();
        }
    }

    beginResetModel();
    m_banners.clear();
    QJsonObject jsonObjet= QJsonDocument::fromJson(bannerData).object();
    if (jsonObjet.empty()) {
        return;
    }
    int code = jsonObjet["code"].toInt();
    if (code != 200) {
        return;
    }
    auto jsonArray = jsonObjet["apps"].toArray();
    foreach (auto json, jsonArray) {
        QString appName;
        QString banner =  json["banner"].toString();
        appName =  json["appName"].toString();
        if (!appName.isEmpty()) {
            m_banners.append(new BannerAppResource(appName,banner));
        }
    }
    endResetModel();
}

