/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
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

};

#endif // NETWORKUTILS_H
