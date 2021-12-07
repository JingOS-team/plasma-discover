/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
#ifndef NETWORKUTILS_H
#define NETWORKUTILS_H

#include <QObject>
#include <resources/AbstractResource.h>
#include "network/HttpClient.h"
#include "discovercommon_export.h"

class DISCOVERCOMMON_EXPORT NetworkUtils : public QObject
{
    Q_OBJECT
public:
    NetworkUtils();
    enum Status {
        Installed,
        Updated,
        Uninstalled
    };
    static NetworkUtils* global();
    static NetworkUtils* s_self;
    void appStatusReport(Status status, AbstractResource *resource);
    QString readLocalArch();
private:
    QString m_localArch;
};

#endif // NETWORKUTILS_H
