

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.5
import org.kde.kirigami 2.15 as Kirigami

Kirigami.Page {
    id: discoverMain

    property int defaultFontSize: theme.defaultFont.pointSize
    property int defaultWidth: 1920
    property int defaultHeight: 1200

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    background: Rectangle {
        anchors.fill: parent
        color: "#E8EFFF"
    }

    DiscoverLeftPage {
        id: leftPage

        anchors {
            left: parent.left
            leftMargin: 20
            top: parent.top
            topMargin: parent.height * 61 / defaultHeight
            bottom: parent.bottom
        }
        width: discoverMain.width * 500 / defaultWidth
        height: discoverMain.height
    }

    DiscoverRightPage {
        id: rightPage
        
        anchors {
            left: leftPage.right
            top: parent.top
            topMargin: parent.height * 61 / defaultHeight
            bottom: parent.bottom
        }
        width: parent.width - leftPage.width - 20
        height: parent.height
    }
}
