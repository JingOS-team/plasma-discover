/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include "AppClass.h"
#include <QDebug>

AppClass::AppClass() {}
AppClass::AppClass(QString name,QString typeName,QString icon,QString appType,QString iconSelect)
    :mName(name)
    ,mTypeName(typeName)
    ,mIcon(icon)
    ,mAppType(appType)
    ,mIconSelect(iconSelect)
{

}

AppClass::AppClass(QString name,QString typeName,QString appType)
    :mName(name)
    ,mTypeName(typeName)
    ,mAppType(appType)
{
    setIcon(iconCachePath(mTypeName,ICONTYPE::NORMAL));
    setIconSelect(iconCachePath(mTypeName,ICONTYPE::SELECT));
}


QString AppClass::name() const
{
    return mName;
}

void AppClass::setName(QString name) {
    mName = name;
}

QString AppClass::typeName() const
{
    return mTypeName;
}

void AppClass::setTypeName(QString typeName) {
    mTypeName = typeName;
    setIcon(iconCachePath(mTypeName,ICONTYPE::NORMAL));
    setIconSelect(iconCachePath(mTypeName,ICONTYPE::SELECT));
}

QString AppClass::icon() const
{
    return mIcon;
}

QString AppClass::appType() const
{
    return mAppType;
}

void AppClass::setAppType(QString appType) {
    mAppType = appType;
}

QString AppClass::iconSelect() const
{
    return mIconSelect;
}

QString AppClass::iconCachePath(QString typeName,ICONTYPE iconType)
{
    QString iconTypeString = QString::fromUtf8("normal");
    if (iconType == ICONTYPE::SELECT) {
        iconTypeString = QString::fromUtf8("select");
    }
    if (typeName.contains(QString::fromUtf8(" "))) {
        typeName.replace(QString::fromUtf8(" "),QString::fromUtf8("_"));
    }
    typeName = typeName.toLower();
    QString path = QStandardPaths::locate(QStandardPaths::GenericDataLocation, QLatin1String("discover/pkcategories/")+typeName+QLatin1String("_")+iconTypeString+QLatin1String(".png"));
    if (path.isEmpty()) {
        return QLatin1String("");
    }
    QString iconPath = QStringLiteral("file://%1").arg(path);
    return iconPath;
}
