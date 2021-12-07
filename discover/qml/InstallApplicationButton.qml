/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.discover 2.0
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "cus"

ConditionalLoader {
    id: root
    property alias application: listener.resource
    readonly property alias isActive: listener.isActive
    readonly property alias progress: listener.progress
    readonly property alias listener: listener
    property string text: !application.isInstalled ? i18n("GET") : i18n(
                                                         "Uninstall")
    property Component additionalItem: null
    property string categoryTextString: !application.isInstalled ? i18n("GET") : i18n(
                                                                       "OPEN")
    property string installTextString: !application.isInstalled ? i18n("GET") : i18n(
                                                                      "Uninstall")
    property string updateTextString: application.canUpgrade ? i18n("Update") : i18n(
                                                                   "OPEN")

    property int defaultFontSize:14 * appFontSize//theme.defaultFont.pointSize

    property bool compact: false
    property int textSize: defaultFontSize

    signal updateButtonClicked

    TransactionListener {
        id: listener
    }

    readonly property Kirigami.Action action: Kirigami.Action {
        text: root.text
        icon {
            name: application.isInstalled ? "trash-empty" : "cloud-download"
            color: !enabled ? Kirigami.Theme.backgroundColor : !listener.isActive ? (application.isInstalled ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.positiveTextColor) : Kirigami.Theme.backgroundColor
        }
        enabled: !listener.isActive
                 && application.state !== AbstractResource.Broken
        onTriggered: root.click()
    }
    readonly property Kirigami.Action cancelAction: Kirigami.Action {
        text: i18n("Cancel")
        icon.name: "dialog-cancel"
        enabled: listener.isCancellable
        onTriggered: listener.cancel()
        visible: listener.isActive
    }

    JAlertDialog {
        id: uninstallDialog

        onDialogLeftClicked: {
            uninstallDialog.close()
        }
        onDialogRightClicked: {
            uninstallDialog.close()
            ResourcesModel.removeApplication(application)
        }
    }

    function click() {
        if (!isActive) {
            if (text === i18n("Uninstall")) {
                uninstallDialog.open()
            } else if (text === i18n("GET")) {
                ResourcesModel.installApplication(application)
            } else if (text === i18n("OPEN")) {
                application.invokeApplication()
            } else if (text === i18n("Update")) {
                updateButtonClicked()
            }
        } else {
            console.warn("trying to un/install but resource still active",
                         application.name)
        }
    }

    condition: listener.isActive
    componentTrue: LabelBackground {
        progress: listener.progress / 100
    }

    componentFalse: Button {
        id: textButton

        enabled: application.state !== AbstractResource.Broken
        contentItem: Text {
            id: installText
            color: Kirigami.JTheme.majorForeground//"black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.text
            font.pixelSize: textSize
        }
        background: Rectangle {
            id: installBg
            color: Kirigami.JTheme.cardBackground
            radius: height / 5
            border.color: listener.progress > 0 ? "transparent" : Kirigami.JTheme.disableForeground//"#CDD0D7"
            border.width: 1
            Rectangle {
                id: hoverRect
                anchors.fill: parent
                opacity: 0
                color: Kirigami.JTheme.majorForeground
                radius: installBg.radius
                MouseArea{
                    width: parent.width + 10 * appScaleSize
                    height: parent.height + 10 * appScaleSize
                    hoverEnabled: true
                    onEntered: {
                        hoverRect.opacity = 0.2
                    }

                    onExited: {
                        hoverRect.opacity = 0
                    }

                    onPressed: {
                        hoverRect.opacity = 0.4
                    }
                    onReleased: {
                        hoverRect.opacity = 0
                    }
                    onCanceled: {
                        hoverRect.opacity = 0
                    }
                    onClicked: {
                        root.click()
                    }
                }
            }
        }

        icon.name: compact ? root.action.icon.name : ""
        focus: true
        onClicked: root.click()
    }
}
