/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#ifndef HTTP_CLIENT_H
#define HTTP_CLIENT_H

#include "HttpRequest.h"
#include "HttpResponse.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include "discovercommon_export.h"

#define BASE_URL "https://search.deepinos.org.cn/"

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
