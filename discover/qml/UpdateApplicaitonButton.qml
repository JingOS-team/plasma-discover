
/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.1
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import org.kde.discover 2.0
import org.kde.kirigami 2.0 as Kirigami
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
            font.pixelSize: delegateArea.defaultFontSize - 5
        }
        background: Rectangle {
            id: installBg
            color: "#F2FBFBFB"
            radius: height / 5
            layer.enabled: true
            border.color: "#CDD0D7"
            layer.effect: DropShadow {
                id: rectShadow
                anchors.fill: installBg
                color: "#12000000"
                source: installBg
                samples: 9
                radius: 4
                horizontalOffset: 0
                verticalOffset: 0
                spread: 0
            }
        }

        icon.name: compact ? root.action.icon.name : ""
        focus: true
        onClicked: root.click()
    }
}
