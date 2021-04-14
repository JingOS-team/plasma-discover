

/*
 *   SPDX-FileCopyrightText: 2012 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *                           2021 Wang Rui <wangrui@jingos.com>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */
import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import org.kde.discover.app 1.0
import org.kde.kirigami 2.0 as Kirigami

Control {
    id: root

    property alias text: theLabel.text
    property real progress: 0.0

    background: Item {
        Rectangle {
            color: "#0D000000"
            anchors.fill: parent
            radius: height / 5
        }

        Rectangle {
            anchors {
                fill: parent
                rightMargin: (1 - root.progress) * parent.width
            }
            color: "#D93C4BE8"
            radius: height / 5
            border.color: "#CDD0D7"
        }
    }

    contentItem: Label {
        id: theLabel
        
        horizontalAlignment: Text.AlignHCenter
        color: Kirigami.Theme.highlightedTextColor
    }
}
