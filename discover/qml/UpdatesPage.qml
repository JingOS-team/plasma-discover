import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import QtQuick 2.4
import org.kde.discover 2.0
import org.kde.discover.app 1.0
import "navigation.js" as Navigation
import org.kde.kirigami 2.10 as Kirigami
import "cus/"

DiscoverPage {
    id: page
    title: i18n("Updates")

    property string footerLabel: ""
    property string footerToolTip: ""
    property int footerProgress: 0
    property bool isBusy: false

    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0
    topPadding: 0

    readonly property var resourcesUpdatesModel: ResourcesUpdatesModel {
        id: resourcesUpdatesModel
        onPassiveMessage: {
            desc.text += message + "<br/>\n"
            sheet.sheetOpen = true
        }
        onIsProgressingChanged: {
            if (!isProgressing) {
                resourcesUpdatesModel.prepare()
            }
        }

        Component.onCompleted: {
            if (!isProgressing) {
                resourcesUpdatesModel.prepare()
            }
        }
    }

    readonly property var sheet: Kirigami.OverlaySheet {
        id: sheet
        parent: applicationWindow().overlay

        header: Kirigami.Heading {
            text: i18n("Update Issue")
        }

        ColumnLayout {
            Label {
                id: desc
                Layout.fillWidth: true
                textFormat: Text.StyledText
                wrapMode: Text.WordWrap
            }

            Button {
                id: okButton
                Layout.alignment: Qt.AlignRight
                text: i18n("OK")
                icon.name: "dialog-ok"
                onClicked: {
                    sheet.sheetOpen = false
                }
            }
        }

        onSheetOpenChanged: if (!sheetOpen) {
                                desc.text = ""
                            } else {
                                okButton.focus = true
                            }
    }

    readonly property var updateModel: UpdateModel {
        id: updateModel
        backend: resourcesUpdatesModel
    }

    footer: ColumnLayout {
        width: parent.width
        spacing: 0

        ScrollView {
            id: scv
            Layout.fillWidth: true
            Layout.preferredHeight: visible ? Kirigami.Units.gridUnit * 10 : 0
            visible: false
            TextArea {
                readOnly: true
                text: log.contents

                cursorPosition: text.length - 1
                font.family: "monospace"

                ReadFile {
                    id: log
                    filter: ".*ALPM-SCRIPTLET\\] .*"
                    path: "/var/log/pacman.log"
                }
            }
        }
        ToolBar {
            id: footerToolbar
            Layout.fillWidth: true
            visible: false //(updateModel.totalUpdatesCount > 0 && resourcesUpdatesModel.isProgressing) || updateModel.hasUpdates

            position: ToolBar.Footer

            CheckBox {
                anchors.left: parent.left
                anchors.leftMargin: Kirigami.Units.gridUnit + Kirigami.Units.smallSpacing
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: page.unselected === 0 ? i18n("All updates selected (%1)",
                                                   updateModel.toUpdateCount) : i18np(
                                                  "%1/%2 update selected (%3)",
                                                  "%1/%2 updates selected (%3)",
                                                  updateModel.toUpdateCount,
                                                  updateModel.totalUpdatesCount,
                                                  updateModel.updateSize)
                enabled: updateAction.enabled
                         && !resourcesUpdatesModel.isProgressing
                         && !ResourcesModel.isFetching
                tristate: true
                checkState: updateModel.toUpdateCount
                            === 0 ? Qt.Unchecked : updateModel.toUpdateCount
                                    === updateModel.totalUpdatesCount ? Qt.Checked : Qt.PartiallyChecked

                onClicked: {
                    if (updateModel.toUpdateCount === 0)
                        updateModel.checkAll()
                    else
                        updateModel.uncheckAll()
                }
            }
        }
    }

    Kirigami.Action {
        id: cancelUpdateAction
        iconName: "dialog-cancel"
        text: i18n("Cancel")
        enabled: resourcesUpdatesModel.transaction
                 && resourcesUpdatesModel.transaction.isCancellable
        onTriggered: resourcesUpdatesModel.transaction.cancel()
    }

    readonly property int unselected: (updateModel.totalUpdatesCount - updateModel.toUpdateCount)

    supportsRefreshing: true
    onRefreshingChanged: {
        ResourcesModel.updateAction.triggered()
        refreshing = false
    }

    readonly property Item report: ColumnLayout {
        parent: page
        anchors.fill: parent
        Item {
            Layout.fillHeight: true
            width: 1
        }

        LoaderAnimation {
            id: loaderAnim
            anchors.fill: parent
            timerRun: visible
            visible: page.isBusy
            onVisibleChanged: {
                updatesView.opacity = visible ? 0 : 1
            }
        }

        ProgressBar {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.leftMargin: Kirigami.Units.largeSpacing * 2
            Layout.rightMargin: Kirigami.Units.largeSpacing * 2
            Layout.maximumWidth: Kirigami.Units.gridUnit * 20
            value: page.footerProgress
            from: 0
            to: 100
            visible: page.isBusy
        }

        NullPageView {
            anchors.centerIn: parent
            visible: page.footerProgress === 0 && page.footerLabel !== ""
                     && !page.isBusy
            onDeviceNetworkStateChanged: {
                if(state === "2" & visible){
                    ResourcesModel.updateAction.triggered()
                }
            }
        }
        Kirigami.Icon {
            Layout.alignment: Qt.AlignHCenter
            visible: false
            source: "update-none"
            implicitWidth: Kirigami.Units.gridUnit * 4
            implicitHeight: Kirigami.Units.gridUnit * 4
            enabled: false
        }
        Kirigami.Heading {
            id: statusLabel
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            text: page.footerLabel
            ToolTip.text: page.footerToolTip
            ToolTip.visible: hovered && page.footerToolTip.length > 0
            ToolTip.delay: Kirigami.Units.toolTipDelay
            level: 3
            visible: false
        }
        Button {
            id: restartButton
            Layout.alignment: Qt.AlignHCenter
            text: i18n("Restart")
            visible: false
            onClicked: app.reboot()
        }
        Item {
            Layout.fillHeight: true
            width: 1
        }
    }

    JGridView {
        id: updatesView
        anchors.fill: parent
        maximumColumns: 3
        maximumColumnWidth: updatesView.width / 3
        cellHeight: cellWidth / 2
        cellWidth: updatesView.width / 3
        interactive: false
        currentIndex: -1

        displaced: Transition {
            YAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        model: updateModel

        delegate: UpdateApplicationDelegate {
            id: appDelegate
            width: updatesView.cellWidth - updatesView.gridSpacing
            height: updatesView.cellHeight - updatesView.gridSpacing
            application: resourceApp
        }
    }

    function getDetails(app, ispkg) {
        page.isBusy = true
        var appNameString = (ispkg & app.appstreamId !== "") ? app.appstreamId : app.packageName
        ispkg = app.appstreamId !== "" ? ispkg : false
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                console.log('HEADERS_RECEIVED')
            } else if (xhr.readyState === XMLHttpRequest.DONE) {

                var object = JSON.parse(xhr.responseText.toString())
                console.log("appDetails:\n", JSON.stringify(object, null, 2))
                var code = object.code
                if (code !== 200) {
                    console.log("request error: " + code)
                    page.isBusy = false
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
                    page.isBusy = false
                    return
                }
                var icon = object.icon
                if (icon === null || icon.length < 1) {
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
                app.screenShots = screenShotsJson
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
                createDetailsActions(app, icon, name, categories,
                                     appSummary, appScreenShots,
                                     description, versionName,
                                     pkgSize, updateDate, author, homePage,
                                     resourcesUpdatesModel)
                delay(3000, function () {
                    page.isBusy = false
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

    readonly property alias secSinceUpdate: resourcesUpdatesModel.secsToLastUpdate
    state: (resourcesUpdatesModel.isProgressing ? "progressing" : ResourcesModel.isFetching ? "fetching" : updateModel.hasUpdates ? "has-updates" : resourcesUpdatesModel.needsReboot ? "reboot" : secSinceUpdate < 0 ? "unknown" : secSinceUpdate === 0 ? "now-uptodate" : secSinceUpdate < 1000 * 60 * 60 * 24 ? "uptodate" : secSinceUpdate < 1000 * 60 * 60 * 24 * 7 ? "medium" : "low")

    states: [
        State {
            name: "fetching"
            PropertyChanges {
                target: page
                footerLabel: i18nc("@info", "Fetching updates...")
            }
            PropertyChanges {
                target: statusLabel
                enabled: true
            }
            PropertyChanges {
                target: page
                footerProgress: ResourcesModel.fetchingUpdatesProgress
            }
            PropertyChanges {
                target: page
                footerToolTip: {
                    var ret = ""
                    for (var i in ResourcesModel.backends) {
                        var backend = ResourcesModel.backends[i]
                        if (!backend.isFetching)
                            continue
                        ret += i18n("%1 (%2%)\n", backend.name,
                                    backend.fetchingUpdatesProgress)
                    }
                    return ret
                }
            }
            PropertyChanges {
                target: page
                isBusy: true
            }
            PropertyChanges {
                target: updatesView
                opacity: 0
            }
        },
        State {
            name: "progressing"
            PropertyChanges {
                target: page
                supportsRefreshing: false
            }
            PropertyChanges {
                target: page.actions
                main: cancelUpdateAction
            }
        },
        State {
            name: "has-updates"
            PropertyChanges {
                target: page
                title: i18nc("@info", "Updates")
            }
            // On mobile, we want "Update" to be the primary action so it's in
            // the center, but on desktop this feels a bit awkward and it would
            // be better to have "Update" be the right-most action
            PropertyChanges {
                target: page.actions
                main: applicationWindow(
                          ).wideScreen ? refreshAction : updateAction
            }
            PropertyChanges {
                target: page.actions
                left: applicationWindow(
                          ).wideScreen ? updateAction : refreshAction
            }
        },
        State {
            name: "reboot"
            PropertyChanges {
                target: page
                footerLabel: i18nc(
                                 "@info",
                                 "The system requires a restart to apply updates")
            }
            PropertyChanges {
                target: statusLabel
                enabled: true
            }
            PropertyChanges {
                target: restartButton
                visible: true
            }
        },
        State {
            name: "now-uptodate"
            PropertyChanges {
                target: page
                footerLabel: i18nc("@info", "Up to date")
            }
            PropertyChanges {
                target: statusLabel
                enabled: false
            }
            PropertyChanges {
                target: page.actions
                main: refreshAction
            }
        },
        State {
            name: "uptodate"
            PropertyChanges {
                target: page
                footerLabel: i18nc("@info", "Up to date")
            }
            PropertyChanges {
                target: statusLabel
                enabled: false
            }
            PropertyChanges {
                target: page.actions
                main: refreshAction
            }
        },
        State {
            name: "medium"
            PropertyChanges {
                target: page
                title: i18nc("@info", "Up to date")
            }
            PropertyChanges {
                target: statusLabel
                enabled: false
            }
            PropertyChanges {
                target: page.actions
                main: refreshAction
            }
        },
        State {
            name: "low"
            PropertyChanges {
                target: page
                title: i18nc("@info", "Should check for updates")
            }
            PropertyChanges {
                target: statusLabel
                enabled: true
            }
            PropertyChanges {
                target: page.actions
                main: refreshAction
            }
        },
        State {
            name: "unknown"
            PropertyChanges {
                target: page
                title: i18nc(
                           "@info",
                           "It is unknown when the last check for updates was")
            }
            PropertyChanges {
                target: statusLabel
                enabled: true
            }
            PropertyChanges {
                target: page.actions
                main: refreshAction
            }
        }
    ]
}
