

/*
 *   SPDX-FileCopyrightText: 2012 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *                           2021 Zhang He Gang <zhanghegang@jingos.com>
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */
import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import "navigation.js" as Navigation
import org.kde.kirigami 2.15 as Kirigami
import "cus/"
import QtGraphicalEffects 1.0

Kirigami.AbstractCard {
    id: delegateArea
    property alias application: installButton.application
    property int installProgress
    property bool compact: false
    property bool showRating: true
    property int defaultFontSize:14 * appFontSize
    property alias installButtonText: installButton.text
    property int itemRadius: 10 * appScaleSize

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
        color: Kirigami.JTheme.cardBackground
        radius: itemRadius
        shadowColor: "#80C3C9D9"
        borderColor: discoverMain.isDarkTheme ? "transparent" : "#C7D3DBEE"
    }

    Component {
        id: highlightComponent
        Rectangle {
            width: delegateArea.width
            height: delegateArea.height
            radius: itemRadius
            color: delegateArea.pressed ?  Kirigami.JTheme.pressBackground : Kirigami.JTheme.hoverBackground
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
            color: "#00FFFFFF"
            border.color: discoverMain.isDarkTheme ? "transparent" : "#CDD0D7"

            border.width: 1
            anchors {
                left: parent.left
                top: contentDetailItem.top
            }
            Image {
                id: bigImageView
                anchors.centerIn: resourceIcon
                width: parent.width - 2
                height: parent.height - 2
                source: application.icon
                visible: false
                asynchronous: true
                fillMode: Image.Stretch
            }

            Rectangle {
                id: maskRect
                anchors.centerIn: resourceIcon
                anchors.fill: bigImageView
                visible: false
                clip: true
                radius: resourceIcon.radius
            }

            OpacityMask {
                id: mask
                anchors.centerIn: resourceIcon
                anchors.fill: maskRect
                source: bigImageView
                maskSource: maskRect
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
            text: i18n("Update")
            textSize: defaultFontSize - 5 * appFontSize
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
                font.pixelSize: delegateArea.defaultFontSize
                font.bold: true
                color: Kirigami.JTheme.majorForeground
            }

            Kirigami.Heading {
                id: category
                anchors {
                    left: parent.left
                    right: parent.right
                }
                Layout.fillWidth: true
                elide: Text.ElideRight
                text: cppClassModel.currentCategoriesName(delegateArea.application.categoryDisplay)
                maximumLineCount: 1
                color: Kirigami.JTheme.minorForeground
                font.pixelSize: delegateArea.defaultFontSize - 4  * appFontSize
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
                color: Kirigami.JTheme.minorForeground
                text: delegateArea.application.comment
                maximumLineCount: 3
                wrapMode: Text.WrapAnywhere
                font.pixelSize: delegateArea.defaultFontSize - 4 * appFontSize
            }
        }
    }
}
