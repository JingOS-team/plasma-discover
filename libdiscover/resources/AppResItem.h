/*
 *   SPDX-FileCopyrightText:      2021 Zhang He Gang <zhanghegang@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#ifndef APPRESITEM_H
#define APPRESITEM_H
#include <QObject>
#include <QString>
#include "AbstractResource.h"

class AppResItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appId READ appId)
    Q_PROPERTY(QString appName READ appName)
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(QString icon READ icon)
    Q_PROPERTY(QString category READ category)
    Q_PROPERTY(QString summary READ summary)
    Q_PROPERTY(AbstractResource *app READ app)

public:
    explicit AppResItem();
    QString appId() const;
    void setAppId(QString appId);
    QString appName() const;
    void setAppName(QString appName);
    QString name() const;
    void setName(QString name);
    QString icon() const;
    void setIcon(QString icon);
    QString category() const;
    void setCategory(QString category);
    QString summary() const;
    void setSummary(QString summary);
    AbstractResource *app();
    void setApp(AbstractResource *app);
private:
    QString m_appId;
    QString m_appName;
    QString m_name;
    QString m_icon;
    QString m_category;
    QString m_summary;
    AbstractResource *m_app;
};
#endif