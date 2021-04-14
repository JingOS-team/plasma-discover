

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

Rectangle {
    color: "#E8EFFF"
    property var imgPathArray

    SwipeView {
        id: view

        anchors {
            top: parent.top
            topMargin: screen.height * 0.1
            left: parent.left
            leftMargin: screen.width * 0.05
            right: parent.right
            rightMargin: screen.width * 0.05
            bottom: parent.bottom
            bottomMargin: screen.height * 0.1
        }

        width: parent.width
        height: screen.height
        currentIndex: 0
        orientation: Qt.Horizontal
        interactive: true
        clip: true
        spacing: 20

        Component.onCompleted: {
            var imgArray = JSON.parse(imgPathArray)
            for (var index in imgArray) {
                var imgPath = imgArray[index].url
                addItem(createPage(imgPath))
            }
        }

        function createPage(imgPath) {
            var component = Qt.createComponent("BigImgItem.qml")
            if (component.status === Component.Ready) {
                var object = component.createObject(view, {
                                                        "x": 0,
                                                        "y": 0
                                                    })
                object.url = imgPath
                object.dismissVisibility = true
                return object
            } else {
                console.log("component create fail: " + component.errorString())
            }
        }
    }

    PageIndicator {
        id: pageIndicator
        
        anchors {
            top: view.bottom
            topMargin: screen.height * 0.03
            horizontalCenter: parent.horizontalCenter
        }
        interactive: true
        count: view.count
        spacing: 10
        currentIndex: view.currentIndex

        delegate: Rectangle {
            width: 24
            height: width
            radius: width / 2
            border.width: 2
            border.color: view.currentIndex === index ? "#B33C3C43" : "#00000000"
            color: "transparent"
            Rectangle {
                anchors.centerIn: parent
                width: 12
                height: width
                radius: width / 2
                color: view.currentIndex === index ? "#B33C3C43" : "#4D3C3C43"
            }
        }
    }
}
