/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
#ifndef BANNERAPPRESOURCE_H
#define BANNERAPPRESOURCE_H

#include <QObject>
#include "discovercommon_export.h"
#include <QFile>
#include <QStandardPaths>
#include <QFileInfo>
#include <QDir>

class DISCOVERCOMMON_EXPORT BannerAppResource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appName READ appName NOTIFY appNameChanged)
    Q_PROPERTY(QString bannerUrl READ bannerUrl NOTIFY bannerUrlChanged)

public:
    explicit BannerAppResource(QString appName,QString bannerUrl,bool isRefresh = false);
    QString appName() {
        return m_appName;
    };
    QString bannerUrl();
    void setAppName(QString appName);
    void setBannerUrl(QString bannerUrl,QString cacheFileName);
Q_SIGNALS:
    void appNameChanged();
    void bannerUrlChanged();
private:
    QString m_appName;
    QString m_bannerUrl;
    bool m_isRefresh;


};

#endif // BANNERAPPRESOURCE_H
