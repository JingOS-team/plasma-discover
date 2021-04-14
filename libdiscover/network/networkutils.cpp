/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include "networkutils.h"

#define REPORT_URL "actionReport"
NetworkUtils::NetworkUtils()
{

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
    QString appName = resource->name();

    QString installedVersion =  resource->installedVersion();
    QJsonObject reportDataJson;
    reportDataJson["appName"] = appName;
    reportDataJson["versionName"] = installedVersion;
    reportDataJson["actionType"] = actionType;
    reportDataJson["resultCode"] = 200;
    reportDataJson["resultMessage"] = "Message";
    reportDataJson["architecture"] = "x86";

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


