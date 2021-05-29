/*
 *   SPDX-FileCopyrightText:      2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#include "bannerappresource.h"
#include "network/HttpClient.h"

BannerAppResource::BannerAppResource(QString appName,QString bannerUrl)
    : m_appName(appName)
    , m_bannerUrl(bannerUrl)
{

}

void BannerAppResource::setAppName(QString appName) {
    if (m_appName != appName) {
        emit appNameChanged();
    }
}
void BannerAppResource::setBannerUrl(QString bannerUrl) {
    m_bannerUrl =  bannerUrl;
    emit bannerUrlChanged();
}
