/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include "HttpClient.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QBuffer>

//using namespace AeaQt;

HttpClient::HttpClient()
{
}

HttpClient::~HttpClient()
{
}
HttpClient *HttpClient::s_self = nullptr;

HttpClient *HttpClient::global()
{
    if (!s_self)
        s_self = new HttpClient;
    return s_self;
}

HttpRequest HttpClient::get(const QString &url)
{
    return HttpRequest(QNetworkAccessManager::GetOperation, this).url(url);
}

HttpRequest HttpClient::post(const QString &url)
{
    return HttpRequest(QNetworkAccessManager::PostOperation, this).url(url);
}

HttpRequest HttpClient::put(const QString &url)
{
    return HttpRequest(QNetworkAccessManager::PutOperation, this).url(url);
}

HttpRequest HttpClient::send(const QString &url, QNetworkAccessManager::Operation op)
{
    return HttpRequest(op, this).url(url);
}
