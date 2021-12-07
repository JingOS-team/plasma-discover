/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import "nav.js" as Nav

Item {
    id: details

    anchors {
        top: parent
        topMargin: 20
    }

    Image {
        id: details_back

        width: 30
        height: 30
        source: "qrc:/img/ic_back.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                Nav.backToAppList()
            }
        }
    }
    Label {
        text: "Details"
        anchors {
            left: details_back.right
            verticalCenter: details_back.verticalCenter
            leftMargin: 20
        }
    }
    Image {
        id: details_app_img
        source: "qrc:/img/logo.png"
        anchors {
            left: parent
            top: details_back.bottom
            topMargin: 50
        }
    }

    Label {
        id: details_app_name
        text: i18n("App")
        font.bold: true
        font.pixelSize: 20
        anchors {
            top: details_back.bottom
            topMargin: 50
            left: details_app_img.right
        }
    }

    Label {
        id: details_app_class
        text: "Social"
        anchors {
            top: details_app_name.bottom
            left: details_app_img.right
            topMargin: 20
        }
    }

    Label {
        id: details_app_info
        width: details.width - 140
        wrapMode: Text.WordWrap
        maximumLineCount: 3
        text: "The world's largest Chinese search engine,Committed to creating excellent.The world's largest Chinese search engine, excellent. The world's largest search engine,Committed to creating excellent. The world's The world's largest Chinese search engine,Committed to creating excellent.The world's largest Chinese search engine, excellent. The world's largest search engine,Committed to creating excellent. The world's "
        anchors {
            top: details_app_class.bottom
            left: details_app_img.right
            topMargin: 10
        }
    }

    ListView {
        id: details_big_img
        anchors {
            top: details_app_info.bottom
            topMargin: 50
            left: details.left
            right: details.right
        }
        orientation: ListView.Horizontal
        height: 200
        width: details.width - 150
        spacing: 30
        clip: true
        model: ListModel {
            ListElement {}
            ListElement {}
            ListElement {}
            ListElement {}
        }
        delegate: Image {
            width: (details.width - 140) / 2
            height: 200
            source: "qrc:/img/t_main.jpg"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Nav.openBigImg()
                }
            }
        }
    }

    Label {
        id: details_app_intro
        text: "Application Introduction"
        anchors {
            top: details_big_img.bottom
            topMargin: 50
        }
        font.bold: true
        font.pixelSize: 30
    }

    Label {
        id: details_intro
        width: details.width
        anchors {
            top: details_app_intro.bottom
            topMargin: 20
        }
        wrapMode: Text.WordWrap
        text: "The world's largest Chinese search engine,Committed to creating excellent.The world's largest Chinese search engine, excellent. The world's largest search engine,Committed to creating excellent. The world's The world's largest Chinese search engine,Committed to creating excellent.The world's largest Chinese search engine, excellent. The world's largest search engine,Committed to creating excellent. The world's "
    }
}
