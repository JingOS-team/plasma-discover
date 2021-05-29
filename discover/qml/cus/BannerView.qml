

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import org.kde.discover 2.0
import org.kde.discover.app 1.0
import "../navigation.js" as Nav

Item {

    id: bannerRootView

    property alias headCount: rcmdApp.count
    property bool leftArrowActive: rcmdApp.count >= 3 ? (rcmdApp.currentIndex !== 0) : false
    property bool rightArrowActive: rcmdApp.count >= 3 ? (rcmdApp.currentIndex
                                                          !== (rcmdApp.count - 1)) : false
    property bool isListViewPress
    signal bannerItemClicked(var bannerName)

    ListView {
        id: rcmdApp
        anchors {
            top: parent.top
        }
        height: parent.height - 20
        width: parent.width
        orientation: Qt.Horizontal
        interactive: true
        clip: true
        spacing: 20
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 500
        maximumFlickVelocity: 10000
        highlightMoveVelocity: 5000
        model: BannerModel

        Component.onCompleted: {
            rcmdApp.currentIndex = 0
        }

        onMovementStarted: {
            isListViewPress = true
        }

        onMovementEnded: {
            isListViewPress = false
        }
        delegate: BigImgItem {
            width: rcmdApp.width
            height: rcmdApp.height
            url: bannerapp.bannerUrl === "" ? "qrc:/img/banner_default.png" : bannerapp.bannerUrl
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    isListViewPress = true
                }
                onReleased: {
                    isListViewPress = false
                }
                onClicked: {
                    bannerItemClicked(bannerapp.appName)
                }
            }
        }
    }

    ArrowView {
        id: leftArrow
        anchors {
            left: rcmdApp.left
            verticalCenter: rcmdApp.verticalCenter
        }
        imageUrl: "qrc:/img/arrow_left.png"
        isActive: leftArrowActive
        width: 50 * appScaleSize
        height: rcmdApp.height
        opacity: 0.0
        onArrowClicked: {
            rcmdApp.currentIndex--
        }
    }

    ArrowView {
        id: rightArrow
        anchors {
            right: bannerRootView.right
            verticalCenter: rcmdApp.verticalCenter
        }
        width: 50 * appScaleSize
        height: rcmdApp.height
        imageUrl: "qrc:/img/arrow_right.png"
        isActive: rightArrowActive
        opacity: 0.0
        onArrowClicked: {
            rcmdApp.currentIndex++
        }
    }

    Timer {
        id: bannerTimer
        interval: 3000
        repeat: true
        running: rcmdApp.count > 1 & !isListViewPress
        onTriggered: {
            if (rcmdApp.currentIndex === (rcmdApp.count - 1)) {
                rcmdApp.currentIndex = 0
                return
            }
            rcmdApp.currentIndex++
        }
    }

    PageIndicator {
        id: pageIndicator
        anchors {
            bottom: rcmdApp.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 7 * appScaleSize
        }

        interactive: false
        visible: count > 1
        count: rcmdApp.count
        spacing: 10 * appScaleSize
        currentIndex: rcmdApp.currentIndex
        delegate: Rectangle {
            width: 5 * appScaleSize
            height: width
            radius: width / 2
            color: rcmdApp.currentIndex === index ? "#B33C3C43" : "#4D3C3C43"
        }
    }
}
