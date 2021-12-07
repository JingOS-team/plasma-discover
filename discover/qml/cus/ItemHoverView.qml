/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
import QtQuick 2.0
import QtQml 2.0

Rectangle {
    id: hoverItem

    property bool isHover: true
    property bool itemHover
    property bool itemPressed
    property bool listMovewMend
    signal itemClicked
    width: 180
    height: 40

    Component {
        id: highlightComponent
        Rectangle {
            width: hoverItem.width
            height: hoverItem.height
            radius: hoverItem.radius
            color: hoverItem.itemPressed ? "#29787880" : "#1F767680"

            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }

    Loader {
        id: hoverLoader
        anchors.fill: hoverItem
        sourceComponent: highlightComponent
        active: hoverItem.itemHover && !hoverItem.itemPressed
    }

    Loader {
        id: pressLoader
        anchors.fill: hoverItem
        sourceComponent: highlightComponent
        active: hoverItem.itemPressed && hoverItem.itemHover
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: isHover
        onExited: itemHover = false
        onEntered: itemHover = true
        onPressed: itemPressed = true
        onReleased: itemPressed = false
        onClicked: {
            itemClicked()
        }
    }
}
