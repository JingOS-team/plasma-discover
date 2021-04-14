

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.5
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import org.kde.discover 2.0
import org.kde.discover.app 1.0

Item {
    id: discoverLeft

    property string leftSearchContent: searchRect.text

    Rectangle {
        id: indexRom

        anchors.left: parent.left
        anchors.leftMargin: 20

        width: parent.width
        height: indexText.contentHeight
        color: "transparent"

        Text {
            id: indexText

            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width
            text: "Store"
            elide: Text.ElideRight
            color: '#FF000000'
            font {
                pointSize: discoverMain.defaultFontSize + 18
                bold: true
            }

            MouseArea {
                anchors.fill: parent

                onDoubleClicked: {
                    Qt.quit()
                }
            }
        }
    }

    Kirigami.JSearchField {
        id: searchRect

        anchors.top: indexRom.bottom
        anchors.topMargin: 20 //searchRect.height / 4
        anchors.left: indexRom.left

        width: discoverLeft.width * 36 / 49
        height: width / 7
        focus: false
        placeholderText: ""
        Accessible.name: qsTr("Search")
        Accessible.searchEdit: true

        background: Rectangle {
            anchors.fill: parent
            color: "#FFFFFF"
            radius: height * 0.36
        }

        onRightActionTrigger: {

        }

        onTextChanged: {
            if (text === "") {
                app_class_list.itemSelectedBackShow = true
                searchRect.focus = false
                againClickCurrentItem()
            }
        }

        onAccepted: {
            if (text !== "") {
                app_class_list.itemSelectedBackShow = false
                rightPage.setCategory(-1, text, true, {})
            }
        }
    }

    Timer {
        id: loadFeatureTimer

        interval: 1000
        onTriggered: {
            rightPage.loaderRun = false
            rightPage.setCategory(0, "", false, app_class_list.firstCategory)
        }
    }

    function againClickCurrentItem() {
        app_class_list.categoryListCurrentItem.currentItem.searchClear()
    }

    function getCurrentItemName() {
        return app_class_list.categoryListCurrentItemName
    }

    JCategoryList {
        id: app_class_list
        
        anchors {
            top: searchRect.bottom
            topMargin: parent.height * 31 / discoverMain.defaultHeight
            bottom: parent.bottom
        }
        width: searchRect.width + 60
        clip: true
        updateCount: ResourcesModel.updatesCount
        categoryModel: cppClassModel

        onFirstCategoryLoaded: {
            loadFeatureTimer.start()
            rightPage.loaderRun = true
        }
        onListItemClicked: {
            searchRect.text = ""
            if (listCount - itemIndex === 2) {
                rightPage.createUpdatePage()
            } else if (listCount - itemIndex === 1) {
                rightPage.createInstallPage()
            } else {
                rightPage.setCategory(itemIndex, "", false, category)
            }
        }
    }
}
