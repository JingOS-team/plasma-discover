

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "nav.js" as Nav
import "../"

Window {
    id: window
    
    width: screen.width
    height: screen.height
    visible: true
    title: qsTr("应用商店")
    Image {
        anchors.fill: parent
        source: "qrc:/img/bg_main.jpg"
    }

    RowLayout {
        ColumnLayout {
            id: store_nav
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: 20
                topMargin: 50
            }
            Layout.preferredWidth: screen.width * 0.3
            RowLayout {
                id: store_title

                Image {
                    id: store_img
                    source: "qrc:/img/logo.png"
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                }

                Label {
                    anchors.left: store_img.right
                    anchors.leftMargin: 10
                    text: "Store"
                    font.bold: true
                    color: "black"
                    font.pointSize: 20
                }
            }

            SearchField {
                id: app_search
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.rightMargin: 50
            }

            Label {
                id: store_class_title
                text: "Application classification"
                color: "#4D000000"
                Layout.topMargin: 40
            }

            ListView {
                id: app_class_list
                Layout.preferredWidth: store_nav.width
                Layout.preferredHeight: 150
                Layout.topMargin: 20
                model: cppClassModel
                delegate: AppClassLayout {}
            }

            Label {
                id: store_my_title
                text: "My"
                color: "#4D000000"
                Layout.topMargin: 160
            }

            ListView {
                Layout.preferredWidth: store_nav.width
                Layout.preferredHeight: 100
                Layout.topMargin: 20
                model: ListModel {
                    ListElement {
                        icon: "qrc:/img/ic_installed.png"
                        name: "Software update"
                    }
                    ListElement {
                        icon: "qrc:/img/ic_update.png"
                        name: "Installed apps"
                    }
                }
                delegate: AppClassLayout {}
            }
        }

        AppDetails {
            id: app_details
            Layout.preferredWidth: screen.width - store_nav.width
            Layout.preferredHeight: screen.height
            Layout.topMargin: 20
            visible: false
        }

        BigImg {
            id: big_img
            Layout.preferredWidth: screen.width - store_nav.width
            Layout.preferredHeight: screen.height
            Layout.topMargin: 20
            visible: false
        }

        ScrollView {
            id: app_scv
            Layout.preferredWidth: screen.width - store_nav.width
            Layout.preferredHeight: screen.height
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ColumnLayout {
                id: app_list
                Layout.preferredWidth: screen.width - store_nav.width
                Layout.preferredHeight: screen.height
                Layout.fillWidth: true
                Image {
                    Layout.preferredWidth: app_scv.width
                    source: "qrc:/img/t_main.jpg"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Nav.openAppDetails()
                        }
                    }
                }

                GridView {
                    id: app_grid
                    Layout.preferredWidth: app_list.width
                    Layout.preferredHeight: 800
                    Layout.topMargin: 30
                    Layout.bottomMargin: 30
                    cellWidth: width / 3
                    cellHeight: 150
                    model: ListModel {
                        ListElement {
                            name: ""
                        }
                    }
                    delegate: AppItem {}
                }
            }
        }
    }
}
