
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
import org.kde.kirigami 2.15 as Kirigami

Rectangle {
    color: Kirigami.JTheme.background //"#E8EFFF"
    property var imgPathArray
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"

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
        spacing: 12 * appScaleSize
        currentIndex: view.currentIndex

        delegate: Rectangle {
            width: 6 * appScaleSize
            height: width
            radius: width / 2
            color: view.currentIndex === index ? Kirigami.JTheme.iconForeground : Kirigami.JTheme.iconMinorForeground //"#B33C3C43" : "#4D3C3C43"
        }
    }
}
