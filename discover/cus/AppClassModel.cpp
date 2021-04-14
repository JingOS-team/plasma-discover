/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include "AppClassModel.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QString>
#include <network/HttpClient.h>
#include <QLocale>
#include <QFileDevice>

#define CACHE_PATH "/usr/share/discover/pkcategories/categoriesinfo.json"

LocalAppModelThread::LocalAppModelThread()
{
}

void LocalAppModelThread::run() 
{
    QString path = QStandardPaths::locate(QStandardPaths::GenericDataLocation, QLatin1String("discover/pkcategories/categoriesinfo.json"));
    QFile app_json(path);
    if (path.isEmpty()) {
        path = CACHE_PATH;
    }
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

void LocalAppModelThread::onNetworkStop(bool isSuc)
{
    isNetworkStop = isSuc;
}

AppClassModel::AppClassModel(QObject *parent):QAbstractListModel(parent)
{
    populate();
}

int AppClassModel::rowCount(const QModelIndex &parent) const
{
    auto categoriesSize = m_categories.size();
    return categoriesSize;
}

QVariant AppClassModel::data(const QModelIndex &index, int role) const
{
    QVariant ret;

    Category *currentCategory = m_categories[index.row()];
    switch (role) {
    case APP_TYPE:
        ret = currentCategory->appType();
        break;
    case CATEGORY:
        ret = QVariant::fromValue(currentCategory);
        break;
    }
    return ret;
}

QHash<int, QByteArray> AppClassModel::roleNames() const
{
    return {
        {NAME, "name"},
        {TYPE_NAME,"type_name"},
        {APP_TYPE,"app_type"},
        {ICON, "icon"},
        {ICON_SELECT,"icon_select"},
        {CATEGORY,"category"}
    };
}

void AppClassModel::populate()
{
    QString systemLan = QLocale::system().bcp47Name();
    if (systemLan.startsWith("zh")) {
        currentLang = "cn";
    } else {
        currentLang = "en";
    }

    localThread = new LocalAppModelThread();
    connect(localThread, &LocalAppModelThread::loadLocalSuc,this, &AppClassModel::createbannerData);
    connect(this, &AppClassModel::networkStop,localThread, &LocalAppModelThread::onNetworkStop);

    iconBaseUrlget();
    categoryCache();
}

void AppClassModel::iconBaseUrlget()
{
    HttpClient::global()->get(QLatin1String(BASE_URL) + QLatin1String(CONFIG_URL))
    .header("content-type", "application/json")
    .queryParam("keyword", "ssr")
    .onResponse([this](QByteArray result) {
        if (result.isEmpty()) {
            return;
        }
        QJsonObject jsonObject = QJsonDocument::fromJson(result).object();
        if (!jsonObject.empty()) {
            QString iconBaseUrl = jsonObject["iconDownloadBase"].toString();
            setIconBaseUrl(iconBaseUrl);
        }
    })
    .onError([this](QString errorStr) {
        return;
    })
    .timeout(10 * 1000)
    .exec();
}

void AppClassModel::setIconBaseUrl(QString iconBaseurl)
{

}


QString AppClassModel::categoryCache()
{
    HttpClient::global()->get(QLatin1String(BASE_URL) + QLatin1String(CATEGORY_URL))
    .header("content-type", "application/json")
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
    .removePublicQueryParams()
    .exec();
    if (localThread->isRunning()) {
        localThread->quit();
    }
    localThread->start();
    return {};
}

void AppClassModel::createbannerData(QByteArray jsonData,bool isNetworkRequest)
{

    if (isNetworkRequest) {
        QString path = QStandardPaths::locate(QStandardPaths::GenericDataLocation, QLatin1String("discover/pkcategories/categoriesinfo.json"));
        QFile app_json(path);
        if (app_json.open(QIODevice::ReadWrite)) {
            QByteArray fileData =  app_json.readAll();
            if (jsonData == fileData) {
                return;
            }
            app_json.resize(0);
            app_json.write(jsonData);
            app_json.close();
        }
    }
    beginResetModel();
    m_categories.clear();
    m_categories.append(new Category(QString::fromUtf8("Feature applications")
                                     ,QString::fromUtf8("feature_applications")
                                     ,QString::fromUtf8(APPTYPE_REMOTE)));

    QJsonObject jsonObjet= QJsonDocument::fromJson(jsonData).object();
    if (jsonObjet.empty()) {
        return;
    }
    int code = jsonObjet["code"].toInt();
    if (code != 200) {
        return;
    }
    QJsonArray jsonArray = jsonObjet["categories"].toArray();
    foreach (auto json, jsonArray) {
        Category *category = new Category();
        category->setApptype(QLatin1String(APPTYPE_REMOTE));
        QJsonObject categoryObject = json.toObject();
        QString typeP =  categoryObject[QString::fromUtf8("type")].toString();
        category->setTypeName(typeP);
        QJsonArray displaysArray = json[QString::fromUtf8("displays")].toArray();
        foreach (auto display, displaysArray) {
            QJsonObject displayObject = display.toObject();
            QString langP =  displayObject[QString::fromUtf8("lang")].toString();
            if (langP == currentLang) {
                QString displayP =  displayObject[QString::fromUtf8("display")].toString();
                category->setName(displayP);
            }
        }
        m_categories.append(category);
    }
    m_categories.append(new Category(QString::fromUtf8("SoftWare update")
                                     ,QString::fromUtf8("SoftWare update")
                                     ,QString::fromUtf8(APPTYPE_LOCAL)));
    m_categories.append(new Category(QString::fromUtf8("Installed apps")
                                     ,QString::fromUtf8("Installed apps")
                                     ,QString::fromUtf8(APPTYPE_LOCAL)));
    endResetModel();
}

