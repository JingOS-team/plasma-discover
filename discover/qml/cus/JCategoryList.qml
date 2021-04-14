

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.0

Item {
    id: categoryListItem

    property alias categoryModel: categoryList.model
    property alias categoryListCurrentIndex: categoryList.itemIndex
    property alias categoryListCurrentItem: categoryList
    property string categoryListCurrentItemName
    property bool itemSelectedBackShow: true

    property int updateCount: 0
    property var firstCategory

    signal listItemClicked(var itemIndex, var listCount, var category)
    signal firstCategoryLoaded(var category)

    Component {
        id: sectionHeading

        Rectangle {

            property string section

            anchors {
                left: parent.left
                leftMargin: 20
            }
            width: categoryList.width
            height: section === "My" ? 70 : 50
            color: "transparent"

            Text {
                anchors.verticalCenter: parent.section === "My" ? parent : parent.verticalCenter
                anchors.bottom: parent.section === "My" ? parent.bottom : parent
                anchors.bottomMargin: parent.section === "My" ? 10 : parent
                text: parent.section
                font.pointSize: discoverMain.defaultFontSize - 2
                color: "#4D000000"
            }
        }
    }

    Component {
        id: updateCountComponent

        Rectangle {
            width: categoryName.contentWidth + 14
            height: updateCount > 9 ? 25 : width
            radius: updateCount > 9 ? 13 : width / 2
            color: "red"

            Text {
                id: categoryName

                anchors.centerIn: parent

                text: updateCount
                font.pointSize: discoverMain.defaultFontSize - 5
                color: "white"
            }
        }
    }

    ListView {
        id: categoryList

        property int itemIndex
        property bool movementEndd

        anchors.fill: parent

        boundsBehavior: Flickable.StopAtBounds
        section.property: "app_type"
        section.criteria: ViewSection.FullString
        section.delegate: sectionHeading
        spacing: 10
        cacheBuffer: height * 2
        currentIndex: itemIndex

        onMovementStarted: {
            movementEndd = false
        }

        onMovementEnded: {
            movementEndd = true
        }

        delegate: ItemHoverView {
            id: categoryItem

            listMovewMend: categoryList.movementEndd
            onListMovewMendChanged: {
                if (!listMovewMend) {
                    itemHover = false
                }
            }

            width: parent.width
            height: width / 6
            radius: height / 4
            color: itemSelectedBackShow & index === categoryList.itemIndex ? "#394BF1" : "#00000000"

            Component.onCompleted: {
                if (index === 0) {
                    categoryListCurrentItemName = category.name
                    firstCategory = category
                    firstCategoryLoaded(category)
                }
            }

            Image {
                id: categoryIcon

                anchors {
                    left: parent.left
                    leftMargin: 20
                    verticalCenter: parent.verticalCenter
                }
                source: itemSelectedBackShow & categoryList.itemIndex
                        === index ? (category.icon_select
                                     === "" ? category.icon : category.icon_select) : category.icon
                sourceSize: Qt.size(32, 32)
                asynchronous: true
            }
            Text {
                id: categoryName

                anchors {
                    left: categoryIcon.right
                    leftMargin: 20
                    verticalCenter: parent.verticalCenter
                }
                text: category.name
                font.pointSize: discoverMain.defaultFontSize
                color: itemSelectedBackShow & index === categoryList.itemIndex ? "white" : "black"
            }

            Loader {
                id: updateCountLoader
                
                anchors {
                    left: categoryName.right
                    leftMargin: 10
                    verticalCenter: categoryName.verticalCenter
                }
                sourceComponent: updateCountComponent
                active: category.name === "SoftWare update" && updateCount > 0
            }

            function searchClear() {
                categoryListItem.listItemClicked(index,
                                                 categoryList.count, category)
            }

            onItemClicked: {
                categoryListCurrentItemName = category.name
                if (categoryList.itemIndex !== index | !itemSelectedBackShow) {
                    categoryList.itemIndex = index
                    categoryListItem.listItemClicked(index, categoryList.count,
                                                     category)
                }
            }
        }
    }
}
