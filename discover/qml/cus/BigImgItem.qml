/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */

import QtQuick 2.15
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../navigation.js" as Nav
import org.kde.kirigami 2.15 as Kirigami

Item {
    id: imgItem
    property var url
    property var dismissVisibility: false
    property int imageRadius: 10 * appScaleSize
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"

    RectDropshadow {
        id: shadow
        color: isDarkTheme ? "transparent" :"#FFFFFF"
        anchors.fill: parent
        radius: imageRadius
        shadowColor: "#80C3C9D9"
        borderColor: isDarkTheme ? "transparent" : "#C7D3DBEE"
    }
    Image {
        id: bigImageView
        width: parent.width - 1
        height: parent.height - 1
        source: url
        visible: false
        asynchronous: true
        fillMode: Image.Stretch
    }

    Rectangle {
        id: maskRect
        anchors.fill: bigImageView
        visible: false
        clip: true
        radius: imageRadius
    }

    OpacityMask {
        id: mask
        anchors.fill: maskRect
        source: bigImageView
        maskSource: maskRect
    }

    Image {
        id: dismiss
        anchors {
            right: imgItem.right
            rightMargin: 12 * appScaleSize
            top: imgItem.top
            topMargin: 12 * appScaleSize
        }
        visible: dismissVisibility
        source: "qrc:/img/ic_close.png"
        width: 22 * appScaleSize
        height: width
        sourceSize: Qt.size(44,44)
        MouseArea {
            anchors.fill: parent
            onClicked: {
                Nav.pop()
            }
        }
    }
}
