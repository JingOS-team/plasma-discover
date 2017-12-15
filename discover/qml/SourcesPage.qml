import QtQuick 2.4
import QtQuick.Controls 1.1
import QtQuick.Controls 2.1 as QQC2
import QtQuick.Layouts 1.1
import org.kde.discover 2.0
import org.kde.discover.app 1.0
import org.kde.kquickcontrolsaddons 2.0
import org.kde.kirigami 2.1 as Kirigami
import "navigation.js" as Navigation

DiscoverPage {
    id: page
    clip: true
    title: i18n("Settings")
    property string search: ""

    readonly property var fu: Instantiator {
        model: SourcesModel
        delegate: QtObject {
            readonly property var sourcesModel: sourceBackend.sources

            readonly property var a: Connections {
                target: sourceBackend
                onPassiveMessage: window.showPassiveNotification(message)
            }
            readonly property var b: AddSourceDialog {
                id: addSourceDialog
                source: sourceBackend
            }

            readonly property var c: MenuItem {
                id: menuItem
                text: sourceBackend.name
                onTriggered: {
                    try {
                        addSourceDialog.open()
                        addSourceDialog.visible = true
                    } catch (e) {
                        console.log("error loading dialog:", e)
                    }
                }
            }

            Component.onCompleted: {
                sourcesMenu.insertItem(0, menuItem)
            }
        }
        onObjectAdded: {
            everySourceModel.addSourceModel(object.sourcesModel)
        }
        onObjectRemoved: {
            everySourceModel.removeSourceModel(object.sourcesModel)
        }
    }

    mainItem: ListView {
        id: sourcesView
        model: QSortFilterProxyModel{
            filterRegExp: new RegExp(page.search)
            sourceModel: KConcatenateRowsProxyModel {
                id: everySourceModel
            }
        }
        currentIndex: -1

        Menu { id: sourcesMenu }

        section {
            property: "statusTip"
            delegate: Kirigami.Heading {
                leftPadding: Kirigami.Units.largeSpacing
                text: section
            }
        }

        headerPositioning: ListView.OverlayHeader
        header: QQC2.ToolBar {
            anchors {
                right: parent.right
                left: parent.left
            }

            contentItem: RowLayout {
                anchors {
                    topMargin: Kirigami.Units.smallSpacing
                    bottomMargin: Kirigami.Units.smallSpacing
                }

                Item {
                    Layout.fillWidth: true
                }

                ToolButton {
                    text: i18n("Application Sources")
                    tooltip: i18n("Allows to choose the source that will be used for browsing applications")
                    menu: Menu {
                        id: backendsMenu
                    }
                    enabled: menu.items.length>0

                    ExclusiveGroup {
                        id: select
                    }

                    Instantiator {
                        model: ResourcesModel.applicationBackends
                        delegate: MenuItem {
                            text: modelData.displayName
                            checkable: true
                            checked: ResourcesModel.currentApplicationBackend == modelData
                            onTriggered: ResourcesModel.currentApplicationBackend = modelData
                            exclusiveGroup: select
                        }
                        onObjectAdded: {
                            backendsMenu.insertItem(index, object)
                        }
                        onObjectRemoved: {
                            object.destroy()
                        }
                    }
                }

                ToolButton {
//                         iconName: "list-add"
                    text: i18n("Add Source")

                    tooltip: text
                    menu: sourcesMenu
                }
                Repeater {
                    model: SourcesModel.actions

                    delegate: RowLayout {
                        Kirigami.Icon {
                            source: modelData.icon
                        }
                        visible: theAction.action && theAction.action.visible
                        ToolButton {
                            height: parent.height
                            action: Action {
                                id: theAction
                                readonly property QtObject action: modelData
                                text: action.text
                                onTriggered: action.trigger()
                                enabled: action.enabled
                            }
                        }
                    }
                }

                ToolButton {
                    text: i18n("More...")
                    menu: Menu {
                        id: actionsMenu
                    }
                    enabled: menu.items.length>0

                    Instantiator {
                        model: MessageActionsModel {}
                        delegate: MenuItem {
                            action: ActionBridge { action: model.action }
                        }
                        onObjectAdded: {
                            actionsMenu.insertItem(index, object)
                        }
                        onObjectRemoved: {
                            object.destroy()
                        }
                    }
                }

                ToolButton {
                    text: i18n("Help...")
                    menu: Menu {
                        MenuItem { action: ActionBridge { action: app.action("help_about_app") } }
                        MenuItem { action: ActionBridge { action: app.action("help_report_bug") } }
                    }
                }
            }
        }


        delegate: Kirigami.SwipeListItem {
            Layout.fillWidth: true
            enabled: display.length>0
            highlighted: ListView.isCurrentItem
            onClicked: Navigation.openApplicationListSource(model.display)
            readonly property string backendName: model.statusTip
            readonly property variant modelIndex: sourcesView.model.index(model.index, 0)

            Keys.onReturnPressed: clicked()
            actions: [
                Kirigami.Action {
                    enabled: display.length>0
                    iconName: "view-filter"
                    tooltip: i18n("Browse the origin's resources")
                    onTriggered: Navigation.openApplicationListSource(model.display)
                },
                Kirigami.Action {
                    iconName: "edit-delete"
                    tooltip: i18n("Delete the origin")
                    onTriggered: {
                        var backend = sourcesView.model.data(modelIndex, AbstractSourcesBackend.SourcesBackend)
                        if (!backend.removeSource(model.display)) {
                            window.showPassiveNotification(i18n("Failed to remove the source '%1'", model.display))
                        }
                    }
                }
            ]

            RowLayout {
                CheckBox {
                    id: enabledBox

                    readonly property variant modelChecked: sourcesView.model.data(modelIndex, Qt.CheckStateRole)
                    checked: modelChecked != Qt.Unchecked
                    enabled: modelChecked !== undefined
                    onClicked: {
                        model.checked = checkedState
                    }
                }
                QQC2.Label {
                    text: model.display + " - <i>" + model.toolTip + "</i>"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }
    }
}
