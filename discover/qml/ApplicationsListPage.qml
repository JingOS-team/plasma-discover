

/*
 *   SPDX-FileCopyrightText: 2012 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *                           2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */
import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import "navigation.js" as Navigation
import org.kde.discover.app 1.0
import org.kde.discover 2.0
import org.kde.kirigami 2.12 as Kirigami
import "cus/"

DiscoverPage {
    id: page
    readonly property var model: appsModel
    property alias category: appsModel.filteredCategory
    property alias sortRole: appsModel.sortRole
    property alias sortOrder: appsModel.sortOrder
    property alias originFilter: appsModel.originFilter
    property alias mimeTypeFilter: appsModel.mimeTypeFilter
    property alias stateFilter: appsModel.stateFilter
    property alias extending: appsModel.extending
    property alias search: appsModel.search
    property alias resourcesUrl: appsModel.resourcesUrl
    property alias isBusy: appsModel.isBusy
    property alias allBackends: appsModel.allBackends
    property alias count: apps.count
    property alias listHeader: apps.header
    property string sortProperty: "appsListPageSorting"
    property bool compact: page.width < 550 || !applicationWindow().wideScreen
    property bool showRating: true

    property bool canNavigate: true
    readonly property alias subcategories: appsModel.subcategories
    property int currentCategoryIndex
    property bool isFetching: ResourcesModel.isFetching
    property alias isNetworking: loaderAnim.visible
    property int defaultFontSize:14//theme.defaultFont.pointSize
    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    function stripHtml(input) {
        var regex = /(<([^>]+)>)/ig
        return input.replace(regex, "")
    }

    title: search.length > 0 ? i18n("Search: %1", stripHtml(
                                        search)) : category ? category.name : ""

    signal clearSearch

    refreshing: false
    supportsRefreshing: true
    onRefreshingChanged: {
        if (refreshing) {
            appsModel.refreshCache()
            //                             appsModel.invalidateFilter()
            refreshing = false
        }
    }

    function componentExit() {
        page.destroy()
    }

    ActionGroup {
        id: sortGroup
        exclusive: true
    }

    contextualActions: [
        Kirigami.Action {
            visible: !appsModel.sortByRelevancy
            text: i18n("Sort: %1", sortGroup.checkedAction.text)
            Action {
                ActionGroup.group: sortGroup
                text: i18n("Name")
                onTriggered: {
                    DiscoverSettings[page.sortProperty] = ResourcesProxyModel.NameRole
                }
                checkable: true
                checked: appsModel.sortRole === ResourcesProxyModel.NameRole
            }
            Action {
                ActionGroup.group: sortGroup
                text: i18n("Rating")
                onTriggered: {
                    DiscoverSettings[page.sortProperty] = ResourcesProxyModel.SortableRatingRole
                }
                checkable: true
                checked: appsModel.sortRole === ResourcesProxyModel.SortableRatingRole
            }
            Action {
                ActionGroup.group: sortGroup
                text: i18n("Size")
                onTriggered: {
                    DiscoverSettings[page.sortProperty] = ResourcesProxyModel.SizeRole
                }
                checkable: true
                checked: appsModel.sortRole === ResourcesProxyModel.SizeRole
            }
            Action {
                ActionGroup.group: sortGroup
                text: i18n("Release Date")
                onTriggered: {
                    DiscoverSettings[page.sortProperty] = ResourcesProxyModel.ReleaseDateRole
                }
                checkable: true
                checked: appsModel.sortRole === ResourcesProxyModel.ReleaseDateRole
            }
        }
    ]

    Component {
        id: headComponent
        BannerView {
            id: gridHeadView
            Component.onCompleted: {
                if (gridHeadView.headCount === 0) {
                    currentCategoryIndex = 1
                }
            }
            onBannerItemClicked: {
                apps.bannerClicked(bannerName)
            }
        }
    }
    TopBar {
        id: listTop
        anchors {
            top: parent.top
        }
        height: search === "" ? 0 : 30 * appScaleSize
        opacity: height === 0 ? 0 : 1
        textCont: i18n("Search Result")
        width: parent.width
        onBackClicked: {
            rightCurrentItem()
        }
    }

    Rectangle {
        id: girdRect
        anchors {
            top: listTop.bottom
            topMargin: search === "" ? 0 : 20 * appScaleSize
        }
        width: parent.width
        height: parent.height - listTop.height
        color: "transparent"
        JGridView {
            id: apps
            signal bannerClicked(var appName)
            anchors.fill: parent
            // Layout.topMargin: 50
            maximumColumns: 3
            maximumColumnWidth: apps.width / 3
            cellHeight: cellWidth / 2
            cellWidth: apps.width / 3
            interactive: true
            visible: true
            clip: true

            onContentYChanged: {
                flickable.contentY = contentY
                        + (currentCategoryIndex === 0 ? page.height * 446 / 1200 : 0)
            }

            onBannerClicked: {
                var findIndex = appsModel.findIndexByName(appName)
                if (findIndex) {
                    getDetails(findIndex, true)
                }
            }

            onModelChanged: {
                isNetworking = false
            }

            model: ResourcesProxyModel {
                id: appsModel
                sortRole: DiscoverSettings.appsListPageSorting
                sortOrder: sortRole === ResourcesProxyModel.SortableRatingRole
                           || sortRole === ResourcesProxyModel.ReleaseDateRole ? Qt.DescendingOrder : Qt.AscendingOrder

                onBusyChanged: {
                    isNetworking = isBusy
                }
            }
            component: ApplicationDelegate {
                application: model.application
                compact: !applicationWindow().wideScreen
                showRating: page.showRating
            }
            header: Item {
                id: rcmdAppContainer
                visible: currentCategoryIndex === 0
                height: visible ? page.height * 446 / 1200 : 0
                width: parent.width - apps.gridSpacing
                Loader {
                    id: headLoader

                    anchors.fill: parent
                    sourceComponent: headComponent
                    active: rcmdAppContainer.visible
                }
            }
        }
    }
    LoaderAnimation {
        id: loaderAnim
        height: parent.height
        width: parent.width
        timerRun: visible
//        visible: appsModel.isBusy
        onVisibleChanged: {
            apps.opacity = visible ? 0 : 1
        }
    }

    Component {
        id: nullComponent
        Rectangle {
            width: page.width
            height: page.height
            color: "transparent"
            NullPageView {
                anchors.centerIn: parent
                onDeviceNetworkStateChanged: {
                    if(state === "2" & visible){
                        appsModel.refreshCache()
                    }
                }
            }
        }
    }

    Loader {
        id: nullLoader
        sourceComponent: nullComponent
        active: apps.count <= 0 & !loaderAnim.visible
    }

    function getDetails(app, ispkg) {
        loaderAnim.visible = true
        var appNameString = app.packageName//(ispkg & app.appstreamId !== "") ? app.appstreamId : app.packageName
        ispkg = app.appstreamId !== "" ? ispkg : false
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            console.log('onreadystatechange:' + xhr.readyState)
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                console.log('HEADERS_RECEIVED')
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var object = JSON.parse(xhr.responseText.toString())
                var code = object.code
                if (code !== 200) {
                    console.log("request error: " + code)
                    loaderAnim.visible = false
                    return
                }
                var appId = object.appId
                if (typeof appId == "undefined" || appId === null
                        || appId.length === 0) {
                    console.log("\nlocal installed app can't open app details page\n")
                    if (ispkg) {
                        getDetails(app, false)
                        return
                    }
                    loaderAnim.visible = false
                    return
                }
                var icon = object.icon
                if(icon){
                    if (icon === null || icon.length < 1) {
                        icon = "qrc:/img/ic_app_details_empty.png"
                    }
                } else {
                    icon = "qrc:/img/ic_app_details_empty.png"
                }
                
                var categories = ""
                for (var i = 0; i < object.categories.length; i++) {
                    categories += object.categories[i]
                    if (i !== object.categories.length - 1) {
                        categories += ","
                    }
                }
                var screenShotsArray = object.screenshots
                var screenShotsJson = JSON.stringify(object.screenshots, null,
                                                     2)
                // if (screenShotsArray == null || screenShotsArray.length < 1) {
                //     screenShotsJson = "[{\"url\":\"qrc:/img/bg_screen_shot_empty.png\", \"type\":\"image\"},{\"url\":\"qrc:/img/bg_screen_shot_empty.png\", \"type\":\"image\"},{\"url\":\"qrc:/img/bg_screen_shot_empty.png\", \"type\":\"image\"}]"
                // }
                if (screenShotsJson !== undefined) {
                    app.screenShots = screenShotsJson
                }
                var appScreenShots = screenShotsJson
                var lang = ""
                if (sysLang === "zh") {
                    lang = "cn"
                } else {
                    lang = "en"
                }
                var name = ""
                var appSummary = ""
                var description = ""
                var author = ""
                var displayDatas = object.displays
                if (displayDatas) {
                    for (var j = 0; j < displayDatas.length; j++) {
                        var display = object.displays[j]
                        if (lang === display.lang) {
                            name = null2Empty(display.name)
                            appSummary = null2Empty(display.summary)
                            description = null2Empty(display.description)
                            author = null2Empty(display.developerName)
                        }
                    }
                }
                var versionName = null2Empty(object.versionName)
                var pkgSize = null2Empty(
                            (object.packageSize / 1024 / 1024).toFixed(1) + "M")
                var updateDate = null2Empty(object.updateDate)
                var homePage = null2Empty(object.homePage)
                createDetailsActions(app, icon, name, categories, appSummary,
                                     appScreenShots, description, versionName,
                                     pkgSize, updateDate, author, homePage)
                delay(3000, function () {
                    loaderAnim.visible = false
                })
            }
        }
        xhr.open("GET",
                 "https://appapi.jingos.com/v1/appinfo?architecture=x86&appName=" + appNameString)
        xhr.send()
    }

    Timer {
        id: timer
    }

    function delay(delayTime, callback) {
        timer.interval = delayTime
        timer.repeat = false
        timer.triggered.connect(callback)
        timer.start()
    }

    function null2Empty(str) {
        return (typeof str == "undefined" || str == null) ? "" : str
    }
}
