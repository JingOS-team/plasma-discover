/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
#ifndef HTTP_CLIENT_H
#define HTTP_CLIENT_H

#include "HttpRequest.h"
#include "HttpResponse.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include "discovercommon_export.h"
//https://search.deepinos.org.cn/
#define BASE_URL "yourself url"

class DISCOVERCOMMON_EXPORT HttpClient : public QNetworkAccessManager
{
    Q_OBJECT
public:
    friend class HttpRequest;

    HttpClient();
    ~HttpClient();

    HttpRequest get(const QString &url);
    HttpRequest post(const QString &url);
    HttpRequest put(const QString &url);
    static HttpClient* global();

    HttpRequest send(const QString &url, Operation op = GetOperation);
    static HttpClient* s_self;

};

//}
#endif
