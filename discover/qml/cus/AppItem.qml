/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "nav.js" as Nav

Item {
    property var itemWidth

    width: calcItemWidth()
    height: itemWidth

    function calcItemWidth() {
        itemWidth = app_grid.cellWidth - 10
        return itemWidth
    }

    Image {
        id: app_img

        anchors {
            left: parent.left
            top: parent.top
        }
        width: w()
        height: w()
        source: application.icon

        function w() {
            return app_grid.cellHeight - 50
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                Nav.openAppDetails()
            }
        }
    }

    Label {
        text: "GET"

        anchors {
            top: app_img.bottom
            horizontalCenter: app_img.horizontalCenter
        }
        font.pixelSize: 15

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("get.........")
            }
        }
    }

    Label {
        id: app_name

        anchors {
            left: app_img.right
            right: parent.right
            leftMargin: 5
        }
        text: application.name
        font.bold: true
        font.pixelSize: 20

        MouseArea {
            anchors.fill: parent
            onClicked: {
                Nav.openAppDetails()
            }
        }
    }

    Label {
        id: app_class

        anchors {
            top: app_name.bottom
            left: app_img.right
            right: parent.right
            leftMargin: 5
            topMargin: 5
        }
        text: "Social"
        color: "#99000000"
        font.pixelSize: 15
        MouseArea {
            anchors.fill: parent
            onClicked: {
                Nav.openAppDetails()
            }
        }
    }

    Label {
        id: app_info

        anchors {
            top: app_class.bottom
            left: app_img.right
            leftMargin: 5
            topMargin: 5
        }
        width: itemWidth - app_img.width
        Layout.preferredWidth: itemWidth - app_img.width
        font.pixelSize: 10
        wrapMode: Text.WordWrap
        maximumLineCount: 3
        elide: Text.ElideRight
        text: "The world's largest Chinese search engine,Committed to creating excellent The world's largest Chinese search engine,Committed to creating excellent"
        color: "#4D000000"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                Nav.openAppDetails()
            }
        }
    }
}
