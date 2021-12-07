/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
#include "networkutils.h"
#include <QFile>
#include <QTextCodec>

#define REPORT_URL "actionReport"
NetworkUtils::NetworkUtils()
{
    readLocalArch();
}

NetworkUtils *NetworkUtils::s_self = nullptr;


NetworkUtils *NetworkUtils::global()
{
    if (!s_self)
        s_self = new NetworkUtils;
    return s_self;
}

void NetworkUtils::appStatusReport(Status status, AbstractResource *resource)
{
    if (!resource) {
        return;
    }
    QString actionType;
    if (status == Installed) {
        actionType = "install";
    } else if (status == Updated) {
        actionType = "update";
    } else if (status == Uninstalled) {
        actionType = "uninstall";
    }
    QString appName = resource->packageName();

    QString installedVersion =  resource->installedVersion();
    QJsonObject reportDataJson;
    reportDataJson["appName"] = appName;
    reportDataJson["versionName"] = installedVersion;
    reportDataJson["actionType"] = actionType;
    reportDataJson["resultCode"] = 200;
    reportDataJson["resultMessage"] = "Message";
    reportDataJson["architecture"] = readLocalArch();

    HttpClient::global() -> post(QLatin1String(BASE_URL) + QLatin1String(REPORT_URL))
    .header("content-type", "application/json")
    .body(reportDataJson)
    .onResponse([this](QByteArray result) {
    })
    .onError([this](QString errorStr) {
        return;
    })
    .timeout(10 * 1000)
    .removePublicQueryParams()
    .exec();
}

QString NetworkUtils::readLocalArch()
{
    if(m_localArch == "") {
        m_localArch = QSysInfo::currentCpuArchitecture();
        if (m_localArch.startsWith("x86")) {
           m_localArch = "x86";
        }
    }
    qWarning()<< " system local architecture:" << m_localArch;
    return m_localArch;
}


