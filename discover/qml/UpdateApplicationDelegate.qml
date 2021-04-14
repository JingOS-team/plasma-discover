

/*
 *   SPDX-FileCopyrightText: 2012 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *                           2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */
import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import "navigation.js" as Navigation
import org.kde.kirigami 2.6 as Kirigami
import "cus/"

Kirigami.AbstractCard {
    id: delegateArea

    property alias application: installButton.application
    property int installProgress
    property bool compact: false
    property bool showRating: true
    property int defaultFontSize: theme.defaultFont.pointSize
    property alias installButtonText: installButton.text

    showClickFeedback: true

    function trigger() {
        if (updatesView.ListView.view)
            updatesView.ListView.view.currentIndex = index
        getDetails(application, true)
    }
    highlighted: updatesView && updatesView.ListView.isCurrentItem
    Keys.onReturnPressed: trigger()
    onClicked: trigger()
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0
    hoverEnabled: true
    background: RectDropshadow {
        color: "#FFFFFF"
        radius: 20
        shadowColor: "#80C3C9D9"
    }

    Component {
        id: highlightComponent

        Rectangle {
            width: delegateArea.width
            height: delegateArea.height
            radius: 20
            color: delegateArea.pressed ? "#29787880" : "#1F767680"
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

        anchors.fill: delegateArea
        sourceComponent: highlightComponent
        active: hovered && !pressed
    }

    Loader {
        id: pressLoader

        anchors.fill: delegateArea
        sourceComponent: highlightComponent
        active: pressed
    }

    contentItem: Item {
        id: contentDetailItem

        property int itemMargins: delegateArea.height * 1 / 8
        anchors {
            top: parent.top
            topMargin: contentDetailItem.itemMargins
            left: parent.left
            leftMargin: contentDetailItem.itemMargins
            right: parent.right
            rightMargin: contentDetailItem.itemMargins
            bottom: parent.bottom
            bottomMargin: contentDetailItem.itemMargins
        }
        clip: true

        Rectangle {
            id: resourceIcon

            height: (parent.height + contentDetailItem.itemMargins * 2) / 2
            width: height
            radius: height / 10
            color: "#CCFFFFFF"
            anchors {
                left: parent.left
                top: contentDetailItem.top
            }
            Kirigami.Icon {
                id: resourceIconImage

                anchors.centerIn: parent

                source: application.icon
                height: parent.height - 10
                width: parent.height - 10
            }
        }

        InstallApplicationButton {
            id: installButton

            width: resourceIcon.width
            height: width * 2 / 5
            anchors {
                bottom: contentDetailItem.bottom
                left: parent.left
            }
            compact: delegateArea.compact
            text: "Update"
            textSize: defaultFontSize - 3
            onUpdateButtonClicked: {
                updateModel.updateResourceByIndex(index)
            }
        }

        Column {
            id: textColumn

            Layout.fillWidth: true
            spacing: 10
            anchors {
                right: parent.right
                left: resourceIcon.right
                leftMargin: resourceIcon.height / 6
                top: resourceIcon.top
                bottom: parent.bottom
            }

            readonly property bool bigTitle: (head.implicitWidth
                                              + installButton.width) > parent.width

            Kirigami.Heading {
                id: head

                anchors {
                    left: parent.left
                    right: parent.right
                }
                Layout.fillWidth: !category.visible || parent.bigTitle
                elide: Text.ElideRight
                text: delegateArea.application.name
                maximumLineCount: 1
                font.pointSize: delegateArea.defaultFontSize + 2
                font.bold: true
            }

            Kirigami.Heading {
                id: category

                anchors {
                    left: parent.left
                    right: parent.right
                }
                Layout.fillWidth: true
                elide: Text.ElideRight
                text: delegateArea.application.categoryDisplay
                maximumLineCount: 1
                color: "#99000000"
                font.pointSize: delegateArea.defaultFontSize - 5
            }

            Kirigami.Heading {
                id: summary
                
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: textColumn.height - category.contentHeight - head.contentHeight - 20
                elide: Text.ElideRight
                verticalAlignment: Text.AlignTop
                color: "#4D000000"
                text: delegateArea.application.comment
                maximumLineCount: 3
                wrapMode: Text.WrapAnywhere
                font.pointSize: delegateArea.defaultFontSize - 5
            }
        }
    }
}
