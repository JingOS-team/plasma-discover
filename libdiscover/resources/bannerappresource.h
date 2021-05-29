/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#ifndef BANNERAPPRESOURCE_H
#define BANNERAPPRESOURCE_H

#include <QObject>
#include "discovercommon_export.h"

class DISCOVERCOMMON_EXPORT BannerAppResource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appName READ appName NOTIFY appNameChanged)
    Q_PROPERTY(QString bannerUrl READ bannerUrl NOTIFY bannerUrlChanged)

public:
    explicit BannerAppResource(QString appName,QString bannerUrl);
    QString appName() {
        return m_appName;
    };
    QString bannerUrl() {
        return m_bannerUrl;
    };
    void setAppName(QString appName);
    void setBannerUrl(QString bannerUrl);
Q_SIGNALS:
    void appNameChanged();
    void bannerUrlChanged();
private:
    QString m_appName;
    QString m_bannerUrl;


};

#endif // BANNERAPPRESOURCE_H
