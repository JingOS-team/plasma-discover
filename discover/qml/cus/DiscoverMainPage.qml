/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
import QtQuick 2.5
import org.kde.kirigami 2.15 as Kirigami

Kirigami.Page {
    id: discoverMain

    property int defaultFontSize: 14 * appFontSize
    property int defaultWidth: 1920
    property int defaultHeight: 1200
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    background: Rectangle {
        anchors.fill: parent
        color: Kirigami.JTheme.background
    }

    DiscoverLeftPage {
        id: leftPage
        anchors {
            left: parent.left
            leftMargin: 20 * appScaleSize
            top: parent.top
            topMargin: 41 * appScaleSize
            bottom: parent.bottom
        }
        width: 225 * appScaleSize
        height: discoverMain.height
    }

    DiscoverRightPage {
        id: rightPage
        anchors {
            left: leftPage.right
            top: parent.top
            topMargin: 41 * appScaleSize
            bottom: parent.bottom
        }
        width: parent.width - leftPage.width - 20 * appScaleSize
        height: parent.height
    }
}
