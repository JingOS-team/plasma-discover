
/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
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
    property string netStateValue: ResourcesModel.networkState
    property bool isFirstLoad: true

    onNetStateValueChanged: {
        if ("1" !== netStateValue) {
            cppClassModel.categoryCache()
            BannerModel.loadBannerData()
        }
    }
    Rectangle {
        id: indexRom
        anchors.left: parent.left
        anchors.leftMargin: 10 * appScaleSize

        width: parent.width
        height: 30 * appScaleSize
        color: "transparent"

        Text {
            id: indexText

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width
            text: i18n("Store")
            elide: Text.ElideRight
            color: Kirigami.JTheme.majorForeground
            font {
                pixelSize: discoverMain.defaultFontSize + 11 * appFontSize
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
        anchors.topMargin: 20 * appScaleSize
        anchors.left: parent.left
        anchors.leftMargin: 5 * appScaleSize

        width: 180 * appScaleSize
        focus: false
        placeholderText: ""
        Accessible.name: i18n("Search")
        Accessible.searchEdit: true
        font.pixelSize: 17 * appFontSize

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
            topMargin: 20 * appScaleSize
            bottom: parent.bottom
            bottomMargin: 20 * appScaleSize
        }
        width: searchRect.width + 40 * appScaleSize
        clip: true
        updateCount: ResourcesModel.updatesCount
        categoryModel: cppClassModel

        onFirstCategoryLoaded: {
            loadFeatureTimer.start()
            rightPage.loaderRun = true
        }
        onListItemClicked: {
            isFirstLoad = false
            if (searchRect.text === "" & searchRect.focus) {
                app_class_list.itemSelectedBackShow = true
                searchRect.focus = false
            } else {
                searchRect.text = ""
            }
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
