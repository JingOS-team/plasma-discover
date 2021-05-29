/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick 2.15
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../navigation.js" as Nav

Item {
    id: imgItem
    property var url
    property var dismissVisibility: false
    property int imageRadius: 10 * appScaleSize
    RectDropshadow {
        id: shadow
        color: "#FFFFFF"
        anchors.fill: parent
        radius: imageRadius
        shadowColor: "#80C3C9D9"
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
