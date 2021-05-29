/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include <QAbstractListModel>
#include <QObject>
#include <QVector>
#include <QDebug>
#include "AppClass.h"
#include <QStandardPaths>
#include "Category/Category.h"
#include <QThread>
#include <KLocalizedString>

#define APPTYPE_REMOTE "Application classification"
#define APPTYPE_LOCAL "My"
#define CATEGORY_URL "categorys"
#define CONFIG_URL "appinfo/search"

class LocalAppModelThread :public QThread
{
    Q_OBJECT
public:
    LocalAppModelThread();
    void run() override;
Q_SIGNALS:
    void loadLocalSuc(QByteArray data,bool isNetworkRequest);
    void iconBaseUrl(QString url);
public Q_SLOTS:
    void onNetworkStop(bool isSuc);
private:
    bool isNetworkStop = false;
};

class AppClassModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ClassRoleTypes
    {
        NAME,
        TYPE_NAME,
        ICON,
        APP_TYPE,
        ICON_SELECT,
        CATEGORY
    };
    enum ICONTYPE
    {
        NORMAL,
        SELECT
    };
    explicit AppClassModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void populate();
    Q_SCRIPTABLE QString categoryCache();
    void iconBaseUrlget();
    Q_SCRIPTABLE QString currentCategoriesName(QString categories);
    QString currentLang = "en";

Q_SIGNALS:
    void networkStop(bool isSuc);
public Q_SLOTS:
    void createbannerData(QByteArray bannerData,bool isNetworkRequest);
    void setIconBaseUrl(QString iconBaseurl);

private:
    QVector<AppClass*> mAppClasses;
    QVector<Category*> m_categories;
    LocalAppModelThread *localThread;
    QMap<QString, QVariant> headers;
    QMap<QString, QString> m_cacheCategoriesMap;
    QString etag;
    QString lastModified;
    QString appTypeRemote = i18n("Application classification");
    QString appTypeMy = i18n("My");

};
