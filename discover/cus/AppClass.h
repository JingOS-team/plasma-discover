/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
#ifndef APPCLASS_H
#define APPCLASS_H
#include <QObject>
#include <QString>
#include <QStandardPaths>

class AppClass:public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString icon READ icon NOTIFY iconChanged)
    Q_PROPERTY(QString icon_select READ iconSelect NOTIFY iconSelectChanged)

public:
    explicit AppClass();
    explicit AppClass(QString name,QString typeName,QString icon,QString appType,QString iconSelect);
    explicit AppClass(QString name,QString typeName,QString appType);

    enum ICONTYPE
    {
        NORMAL,
        SELECT
    };

    QString name() const;
    void setName(QString name);
    QString typeName() const;
    void setTypeName(QString typeName);
    QString icon() const;
    void setIcon(QString iconPath) {
        if (mIcon == iconPath)
            return;
        mIcon = iconPath;
        emit iconChanged();
    }
    QString appType() const;
    void setAppType(QString appType);
    QString iconSelect() const;
    void setIconSelect(QString iconSelectPath) {
        if (mIcon == iconSelectPath)
            return;
        mIconSelect = iconSelectPath;
        emit iconChanged();
    }
    QString iconCachePath(QString typeName,ICONTYPE iconType);

Q_SIGNALS:
    void iconChanged();
    void iconSelectChanged();
private:
    QString mName;
    QString mTypeName;
    QString mIcon;
    QString mAppType;
    QString mIconSelect;
};
#endif
