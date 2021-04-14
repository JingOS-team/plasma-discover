

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.0
import "../../qml"
import QtQml.Models 2.3
import org.kde.kirigami 2.15 as Kirigami
import org.kde.discover 2.0
import org.kde.discover.app 1.0

Rectangle {
    id: discoverRight

    color: "#0000ff00"
    property string categoryName: "Games"
    property string softUpdateName: "SoftWare update"
    property Component componentqml: Qt.createComponent(
                                         "qrc:/qml/ApplicationsListPage.qml")
    property var qmlObject
    property var tmpObject
    property Component topUpdateComp: Qt.createComponent(
                                          "qrc:/qml/UpdatesPage.qml")
    property Component topInstalledComp: Qt.createComponent(
                                             "qrc:/qml/InstalledPage.qml")
    property bool loaderRun
    property bool isFetching: ResourcesModel.isFetching

    onIsFetchingChanged: {
        if (!isFetching & _browserList.count < 2) {
            rightCurrentItem()
        }
        if (!isFetching & getLeftMenuName() === softUpdateName) {
            rightCurrentItem()
        }
    }

    ListView {
        id: _browserList

        cacheBuffer: height * 1.5
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        clip: true
        focus: true
        orientation: ListView.Horizontal
        model: tabsObjectModel
        snapMode: ListView.SnapOneItem
        spacing: 0
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        highlightResizeDuration: 0
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: width
        highlight: Item {}
        highlightMoveVelocity: -1
        highlightResizeVelocity: -1
        boundsBehavior: Flickable.StopAtBounds
        currentIndex: tabsObjectModel.count > 1 ? tabsObjectModel.count - 1 : 0
        interactive: false
    }

    ObjectModel {
        id: tabsObjectModel
    }

    function setCategory(index, searchText, isSearch, currentCategory) {
        if (!isSearch) {
            categoryName = categoryName === "Office" ? "Games" : "Office"
        }
        createCategoryActions(index, searchText, currentCategory)
    }

    function createUpdatePage() {
        if (topUpdateComp.status === Component.Ready) {
            qmlObject = topUpdateComp.incubateObject(tabsObjectModel, {
                                                         "width": _browserList.width,
                                                         "height": _browserList.height
                                                     })

            if (qmlObject) {
                if (qmlObject.status !== Component.Ready) {
                    qmlObject.onStatusChanged = function (status) {
                        if (status === Component.Ready) {
                            tabsObjectModel.clear()
                            tabsObjectModel.append(qmlObject.object)
                        }
                    }
                } else if (qmlObject.status === Component.Ready) {
                    tabsObjectModel.clear()
                    tabsObjectModel.append(qmlObject.object)
                }
            }
        }
    }

    function createInstallPage() {
        if (topInstalledComp.status === Component.Ready) {
            qmlObject = topInstalledComp.incubateObject(tabsObjectModel, {
                                                            "width": _browserList.width,
                                                            "height": _browserList.height
                                                        })

            if (qmlObject) {
                if (qmlObject.status !== Component.Ready) {
                    qmlObject.onStatusChanged = function (status) {
                        if (status === Component.Ready) {
                            tabsObjectModel.clear()
                            tabsObjectModel.append(qmlObject.object)
                        }
                    }
                } else if (qmlObject.status === Component.Ready) {
                    tabsObjectModel.clear()
                    tabsObjectModel.append(qmlObject.object)
                }
            }
        }
    }

    function createCategoryActions(index, searchText, currentCategory) {
        var category = {}
        if (searchText === "") {
            category = currentCategory //CategoryModel.findCategoryByName(categoryName)
        }

        if (componentqml.status === Component.Ready) {
            qmlObject = componentqml.incubateObject(tabsObjectModel, {
                                                        "width": _browserList.width,
                                                        "height": _browserList.height,
                                                        "category": category,
                                                        "search": searchText,
                                                        "isNetworking": true,
                                                        "currentCategoryIndex": index
                                                    })

            if (qmlObject) {
                if (qmlObject.status !== Component.Ready) {
                    qmlObject.onStatusChanged = function (status) {
                        if (status === Component.Ready) {
                            tabsObjectModel.clear()
                            tabsObjectModel.append(qmlObject.object)
                        }
                    }
                } else if (qmlObject.status === Component.Ready) {
                    tabsObjectModel.clear()
                    tabsObjectModel.append(qmlObject.object)
                }
            }
        }
    }

    function exitDetailsActions() {
        tabsObjectModel.remove(tabsObjectModel.count - 1)
    }
    function rightCurrentItem() {
        leftPage.againClickCurrentItem()
    }

    function getLeftMenuName() {
        return leftPage.getCurrentItemName()
    }

    function getLeftSearchContent() {
        return leftPage.leftSearchContent
    }

    function createDetailsActions(app, icon, name, categoryDisplay, appSummary, appScreenShots, description, versionName, pkgSize, updateDate, author, homePage, currentUpdateModel) {
        var componentDetailQml = Qt.createComponent(
                    "qrc:/qml/ApplicationPage.qml")
        if (componentDetailQml.status === Component.Ready) {
            var buttonTextType = 0
            if (getLeftSearchContent() === "") {
                if (getLeftMenuName() === "Installed apps") {
                    buttonTextType = 1
                } else if (getLeftMenuName() === softUpdateName) {
                    buttonTextType = 2
                }
            }
            var objectDetail = componentDetailQml.incubateObject(
                        tabsObjectModel, {
                            "width": _browserList.width,
                            "height": _browserList.height,
                            "application": app,
                            "icon": icon,
                            "name": name,
                            "categoryDisplay": categoryDisplay,
                            "appSummary": appSummary,
                            "appScreenShots": appScreenShots,
                            "description": description,
                            "versionName": versionName,
                            "pkgSize": pkgSize,
                            "updateDate": updateDate,
                            "author": author,
                            "homePage": homePage,
                            "buttonTextType": buttonTextType,
                            "currentUpdateModel": currentUpdateModel
                        })
            if (objectDetail) {
                if (objectDetail.status !== Component.Ready) {
                    objectDetail.onStatusChanged = function (status) {
                        if (status === Component.Ready) {
                            tabsObjectModel.append(objectDetail.object)
                        }
                    }
                } else if (objectDetail.status === Component.Ready) {
                    tabsObjectModel.append(objectDetail.object)
                }
            }
        }
    }

    LoaderAnimation {
        id: loaderAnim
        
        anchors.fill: parent
        timerRun: visible
        visible: loaderRun | isFetching
    }
}
