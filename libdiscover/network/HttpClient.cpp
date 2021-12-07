/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
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
