

/*
 *   SPDX-FileCopyrightText: 2012 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *                          2021 Wang Rui <wangrui@jingos.com>
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */
import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import org.kde.discover 2.0
import org.kde.discover.app 1.0
import org.kde.kirigami 2.6 as Kirigami
import "navigation.js" as Navigation
import "cus/"
import QtGraphicalEffects 1.0

Column {
    id: appDetailsRoot
    property alias application: appInfo.application
    readonly property alias visibleReviews: appInfo.visibleReviews
    property var vLeftMargin: screen.width * 0.02
    property var icon: ""
    property var name: ""
    property var categoryDisplay: ""
    property var appSummary: ""
    property var appScreenShots: []
    property var description: ""
    property var versionName: ""
    property var pkgSize: ""
    property var updateDate: ""
    property var author: ""
    property var homePage: ""
    property var buttonTextType
    property var currentUpdateModel
    property int iconButtonTopMargin: 20 * appScaleSize
    property int middleMargin: 35 * appScaleSize

    TopBar {
        id: topBar
        height: 30 * appScaleSize
        textCont: getLeftMenuName()
        onBackClicked: {
            exitDetailsActions()
        }
    }

    DiscoverPage {
        id: appInfo
        property QtObject application: null
        readonly property int visibleReviews: 3
        title: appInfo.application.name
        clip: true
        anchors {
            left: parent.left
            leftMargin: screen.width * 0.01
            right: parent.right
            rightMargin: screen.width * 0.02
            top: topBar.bottom
            topMargin: 20 * appScaleSize//topBar.height + 40 + parent.height * 0.03 //parent.height * 0.08
            bottom: appDetailsRoot.bottom
            bottomMargin: parent.height * 0.03
        }

        // Usually this page is not the top level page, but when we are, isHome being
        // true will ensure that the search field suggests we are searching in the list
        // of available apps, not inside the app page itself. This will happen when
        // Discover is launched e.g. from krunner or otherwise requested to show a
        // specific application on launch.
        readonly property bool isHome: true
        function searchFor(text) {
            if (text.length === 0)
                return
            Navigation.openCategory(null, "")
        }

        background: RectDropshadow {
            anchors.fill: parent
            color: "#CCFFFFFF" //Kirigami.Theme.backgroundColor
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            Kirigami.Theme.inherit: false
            radius: 10 * appScaleSize
        }

        contextualActions: [originsMenuAction]

        ActionGroup {
            id: sourcesGroup
            exclusive: true
        }

        Kirigami.Action {
            id: originsMenuAction

            text: i18n("Sources")
            visible: false //children.length>1
            children: sourcesGroup.actions
            readonly property var r0: Instantiator {
                model: ResourcesProxyModel {
                    id: alternativeResourcesModel
                    allBackends: true
                    resourcesUrl: appInfo.application.url
                }
                delegate: Action {
                    ActionGroup.group: sourcesGroup
                    text: model.application.availableVersion ? i18n(
                                                                   "%1 - %2",
                                                                   displayOrigin,
                                                                   model.application.availableVersion) : displayOrigin
                    icon.name: sourceIcon
                    checkable: true
                    checked: appInfo.application === model.application
                    onTriggered: if (index >= 0) {
                                     var res = model.application
                                     console.assert(res)
                                     window.stack.pop()
                                     Navigation.openApplication(res)
                                 }
                }
            }
        }

        Kirigami.Action {
            id: invokeAction
            visible: false //application.isInstalled && application.canExecute && !appbutton.isActive
            text: application.executeLabel
            icon.name: "media-playback-start"
            onTriggered: application.invokeApplication()
        }

        InstallApplicationButton {
            id: appbutton
            Layout.rightMargin: Kirigami.Units.smallSpacing
            application: appInfo.application
            width: parent.width / 10
            height: width * 56 / 179
            visible: true
            text: {
                if (buttonTextType === 1) {
                    return installTextString
                } else if (buttonTextType === 2) {
                    return updateTextString
                } else {
                    return categoryTextString
                }
            }
            anchors {
                right: parent.right
                rightMargin: parent.width * 0.03
                top: parent.top
                topMargin: iconButtonTopMargin 
            }
            onUpdateButtonClicked: {
                currentUpdateModel.updateResource(application)
            }
        }

        leftPadding: vLeftMargin //Kirigami.Units.largeSpacing * (applicationWindow().wideScreen ? 2 : 1)
        rightPadding: vLeftMargin //Kirigami.Units.largeSpacing * (applicationWindow().wideScreen ? 2 : 1)

        Column {
            spacing: 0
            height: 50 + (appDetailsRoot.height * 0.03) + (topBar.height + 40 + parent.height * 0.03 ) + topRow.height + applicationScreenshots.height + appIntro.height + appIntroCont.height + appDetails.height + detailsContent.height
//            height:  appInfo.height + (appDetailsRoot.height * 0.03) + (topBar.height + 40 + parent.height * 0.03 )
//            anchors {
//                bottom: appDetailsRoot.bottom
//            }
            Row {
                id: topRow
                width: parent.width
                height: 90 * appScaleSize
                anchors {
                    top: appbutton.top
                    // topMargin: iconButtonTopMargin
                }
                Rectangle {
                    id: appIcon

                    anchors {
                        left: parent.left
                        top: contentDetailItem.top
                    }
                    height: 90 * appScaleSize
                    width: height
                    radius: height / 10
                    color: "#CCFFFFFF"
                    border.color: "#CDD0D7"
                    border.width: 1

                    Image {
                        id: bigImageView
                        anchors.centerIn: appIcon
                        width: parent.width - 2
                        height: parent.height - 2
                        source: icon
                        visible: false
                        asynchronous: true
                        fillMode: Image.Stretch
                    }

                    Rectangle {
                        id: maskRect
                        anchors.centerIn: appIcon
                        anchors.fill: bigImageView
                        visible: false
                        clip: true
                        radius: appIcon.radius
                    }

                    OpacityMask {
                        id: mask
                        anchors.centerIn: appIcon
                        anchors.fill: maskRect
                        source: bigImageView
                        maskSource: maskRect
                    }
//                    Kirigami.Icon {
//                        id: appIconImage
//                        width: 90 * appScaleSize
//                        height: width
//                        source: icon //appInfo.application.icon
//                    }
                }
                Column {
                    id: clayout
                    spacing: 11
                    anchors {
                        left: appIcon.right
                        leftMargin: parent.width * 0.03
                        right: parent.right
                        verticalCenter: appIcon.verticalCenter
                    }
                    Text {
                        id: namee
                        text: name
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        font.pixelSize: discoverMain.defaultFontSize + 14
                        font.bold: true
                        color: "black"
                    }

                    Label {
                        text: cppClassModel.currentCategoriesName(categoryDisplay) //appInfo.application.categoryDisplay
                        font.pixelSize: discoverMain.defaultFontSize + 3
                        width: 100
                        color: "black"
                    }

                    Text {
                        id: summary
                        text: appSummary //appInfo.application.comment
                        maximumLineCount: 2
                        // lineHeight: lineCount > 1 ? 0.75 : 1.2
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        // Layout.alignment: Qt.AlignTop
                        font.pixelSize: discoverMain.defaultFontSize
                        color: "black"
                        anchors {
                            left: parent.left
                            right: parent.right
                            rightMargin: appbutton.rightMargin
                        }
                    }
                }
            }

            ApplicationScreenshots {
                id: applicationScreenshots
                Layout.fillWidth: true
                width: parent.width
                height: count > 0 ? 144 * appScaleSize : 0
                visible: count > 0
                resource: appInfo.application
                anchors {
                    top: topRow.bottom
                    topMargin: count > 0 ? middleMargin : 0
                }
            }

            Label {
                id: appIntro
                text: i18n("Application Introduction")
                color: '#FF000000'
                font {
                    pixelSize: discoverMain.defaultFontSize + 6
                    bold: true
                }
                width: parent.width
                anchors {
                    top: applicationScreenshots.bottom
                    topMargin: middleMargin
                }
            }

            Label {
                id: appIntroCont
                Layout.fillWidth: true
                width: parent.width
                wrapMode: Text.WordWrap
                text: description//appInfo.application.longDescription
                onLinkActivated: Qt.openUrlExternally(link)
                font.pixelSize: discoverMain.defaultFontSize
                Layout.rightMargin: appbutton.rightMargin
                anchors {
                    top: appIntro.bottom
                    topMargin: screen.height * 0.02
                    right: appbutton.right
                    rightMargin: appbutton.rightMargin
                }
            }

            Label {
                id: appDetails
                text: i18n("Detailed information")
                color: '#FF000000'
                font {
                    pixelSize: discoverMain.defaultFontSize + 6
                    bold: true
                }
                anchors {
                    top: appIntroCont.bottom
                    topMargin: middleMargin
                }
            }


            JFormLayout {
                id:detailsContent
                property int detailTextSize: discoverMain.defaultFontSize

                anchors {
                    top: appDetails.bottom
                }
                Layout.fillWidth: true

                // Version row
                Label {
                    readonly property string version: appInfo.application.isInstalled ? appInfo.application.installedVersion : appInfo.application.availableVersion
                    readonly property string releaseDate: appInfo.application.releaseDate.toLocaleDateString(
                                                              Locale.ShortFormat)

                    function versionString() {
                        if (version.length == 0) {
                            return ""
                        } else {
                            if (releaseDate.length > 0) {
                                return i18n("%1, released on %2", version,
                                            releaseDate)
                            } else {
                                return version
                            }
                        }
                    }

                    Kirigami.FormData.label: i18n("Edition")
                    visible: text.length > 0
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: versionName //versionString()
                    font.pixelSize: detailsContent.detailTextSize
                }

                // Size row
                Label {
                    Kirigami.FormData.label: i18n("Download size")
                    Layout.fillWidth: true
                    Layout.alignment: Text.AlignTop
                    elide: Text.ElideRight
                    text: pkgSize
                    font.pixelSize: detailsContent.detailTextSize
                }

                // Update date
                Label {
                    Kirigami.FormData.label: i18n("Update date")
                    Layout.fillWidth: true
                    Layout.alignment: Text.AlignTop
                    elide: Text.ElideRight
                    text: updateDate
                    font.pixelSize: detailsContent.detailTextSize
                }

                // Author row
                Label {
                    Kirigami.FormData.label: i18n("Developer")
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    visible: text.length > 0
                    text: author //appInfo.application.author
                    font.pixelSize: detailsContent.detailTextSize
                }

                Label {
                    Kirigami.FormData.label: i18n("Website")
                    Layout.fillWidth: true
                    // elide: Text.ElideRight
                    visible: text.length > 0
                    text: homePage //appInfo.application.author
                    font.pixelSize: detailsContent.detailTextSize
                }
            }
        }

        readonly property var addons: AddonsView {
            id: addonsView
            application: appInfo.application
        }
    }
}
