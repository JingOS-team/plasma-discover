


/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick 2.0

Item {
    id: arrowView
    
    property bool isActive
    property string imageUrl
    signal arrowClicked

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            arrowView.opacity = 1.0
        }
        onExited: {
            arrowView.opacity = 0.0
        }
    }

    Component {
        id: leftComponent

        Rectangle {
            id: leftRect
            color: "transparent"
            radius: 6
            width: 42
            height: 42

            Image {
                id: leftImage

                anchors.centerIn: parent
                source: imageUrl
                width: 32
                height: 32
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onExited: {
                    leftRect.color = "transparent"
                    arrowView.opacity = 0.0
                }
                onEntered: {
                    leftRect.color = "#1A000000"
                    arrowView.opacity = 1.0
                }
                onPressed: {
                    leftRect.color = "#26000000"
                }
                onReleased: {
                    leftRect.color = "#1A000000"
                }
                onClicked: {
                    arrowClicked()
                }
            }
        }
    }

    Loader {
        id: leftLoader

        anchors.centerIn: parent
        sourceComponent: leftComponent
        active: isActive
    }
}
