

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.0

Item {

    width: 120
    height: 150

    Image {
        id: nullImage

        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/img/nullpage.png"
        sourceSize: Qt.size(120, 120)
    }

    Text {
        id: nullText
        
        anchors {
            top: nullImage.bottom
            horizontalCenter: nullImage.horizontalCenter
        }
        text: getShowText()
        font.pointSize: defaultFontSize + 8
        color: "#4D3C3C43"
    }

    function getShowText() {
        var state = ResourcesModel.networkState
        if ("1" == state) {
            return qsTr("Currently not connected to the network, please connect and try again")
        } else {
            return qsTr("There is no apps at present")
        }
    }
}
