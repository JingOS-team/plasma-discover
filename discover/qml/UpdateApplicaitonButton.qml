/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
import QtQuick 2.1
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import org.kde.discover 2.0
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

ConditionalLoader {
    id: root
    property bool isActive: false
    property int updateProgress: 0
    readonly property string text: i18n("Update")
    property Component additionalItem: null
    readonly property alias progress: listener.progress
    property alias application: listener.resource
    property bool compact: false

    signal updateButtonClicked

    TransactionListener {
        id: listener
    }

    function click() {
        isActive = !isActive
        updateButtonClicked()
    }

    condition: isActive
    componentTrue: LabelBackground {
        id: lableBack

        progress: listener.progress / 100
    }

    componentFalse: Button {
        enabled: application.state !== AbstractResource.Broken
        contentItem: Text {
            id: installText
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.text
            font.pixelSize: delegateArea.defaultFontSize - 5 * appFontSize
        }
        background: Rectangle {
            id: installBg
            color: Kirigami.JTheme.cardBackground//"#F2FBFBFB"
            radius: height / 5
            layer.enabled: true
            border.color:  listener.progress > 0 ? "transparent" : Kirigami.JTheme.disableForeground//"#CDD0D7"
            Rectangle {
                id: hoverRect
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#1E1E1E" }
                    GradientStop { position: 1.0; color: "#000000"; }
                }
                opacity: 0
                radius: installBg.radius
                MouseArea{
                            anchors.fill: parent
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
