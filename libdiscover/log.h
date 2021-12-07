/*
 *   SPDX-FileCopyrightText:      2021 Zhang He Gang <zhanghegang@jingos.com>
 *   SPDX-License-Identifier:     LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
#ifndef LOG_H
#define LOG_H

#define LOG_ENABLE true

#define D(tag,cont)\
       if (LOG_ENABLE) {\
           qDebug() << "\n";\
           qDebug() << __FILE__ << ":" << __LINE__;\
           qDebug() << tag << ":" << cont;\
           qDebug() << "\n";\
       }

#endif