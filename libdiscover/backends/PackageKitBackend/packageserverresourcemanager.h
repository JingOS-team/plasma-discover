/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
#ifndef PACKAGESERVERRESOURCEMANAGER_H
#define PACKAGESERVERRESOURCEMANAGER_H

#include <QObject>
#include <QTimer>
#include <QHash>
#include <QMap>
#include <QThreadPool>
#include <QSet>
#include "utils.h"

struct ServerData {
    QString appId;
    QString appName;
    QString banner;
    QString icon;
    QString name;
    QString categoryDisplay;
    QString comment;
    QSet<QString> categoriesSet;
};
class PackageServerResourceManager : public QObject
{
    Q_OBJECT
public:
    explicit PackageServerResourceManager(QObject *parent = nullptr);
    ~PackageServerResourceManager();
    QStringList m_serverPackageNames;
    void requestData();
    void loadCacheData();
    bool existPackageName(QString pkgName);
    bool isRunning();
    void refreshData();
    void parseJson(QByteArray jsonData);
    ServerData resourceByName(QString pkgName);
    QList<ServerData> resourceByCategory(QString categoryName);
    QList<ServerData> resourceByKeyword(QString keyword);

private:
    QTimer m_requestDataTimer;
    QHash<QString, ServerData> serverPackages;
    QString versionId;
    QMap<QString, QVariant> headers;
    QString etag;
    QString lastModified;
    QThreadPool m_threadPool;
    bool isCacheData = false;
    bool isNetworking = false;


Q_SIGNALS:
    void loadStart();
    void serverPackage(QString appName,ServerData serverD);
    void loadFinished();
    void loadError(QString error);
};

#endif // PACKAGESERVERRESOURCEMANAGER_H
