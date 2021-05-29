

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.0

Item {

    id:itemNull
    width: 120
    height: 150
    property string netStateValue: ResourcesModel.networkState
    property string preState : "2"

    signal deviceNetworkStateChanged(var state)

    Image {
        id: nullImage
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/img/nullpage.png"
        sourceSize: Qt.size(120, 120)
        width:60 * appScaleSize
        height: 60 * appScaleSize
    }

    Text {
        id: nullText
        anchors {
            top: nullImage.bottom
            horizontalCenter: nullImage.horizontalCenter
        }
        text: getShowText()
        font.pixelSize: defaultFontSize
        color: "#4D3C3C43"
    }

    function getShowText() {
        var state = netStateValue

        if(state !== preState){
            deviceNetworkStateChanged(state)
        }
        preState = state
        if ("1" === state) {
            return i18n("Currently not connected to the network, please connect and try again")
        } else {
            return i18n("There is no apps at present")
        }
    }
}
