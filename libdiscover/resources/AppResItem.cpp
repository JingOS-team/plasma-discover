/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include "AppResItem.h"

AppResItem::AppResItem()
{

}

QString AppResItem::appId() const
{
    return m_appId;
}

void AppResItem::setAppId(QString appId)
{
    m_appId = appId;
}

QString AppResItem::appName() const
{
    return m_appName;
}

void AppResItem::setAppName(QString appName)
{
    m_appName = appName;
}

QString AppResItem::name() const
{
    return m_name;
}

void AppResItem::setName(QString name)
{
    m_name = name;
}

QString AppResItem::icon() const
{
    return m_icon;
}

void AppResItem::setIcon(QString icon)
{
    m_icon = icon;
}

QString AppResItem::category() const
{
    return m_category;
}

void AppResItem::setCategory(QString category)
{
    m_category = category;
}

QString AppResItem::summary() const
{
    return m_summary;
}

void AppResItem::setSummary(QString summary)
{
    m_summary = summary;
}

AbstractResource *AppResItem::app()
{
    return m_app;
}

void AppResItem::setApp(AbstractResource *app)
{
    m_app = app;
}