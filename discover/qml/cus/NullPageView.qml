/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
import QtQuick 2.0
import org.kde.kirigami 2.15 as Kirigami

Item {

    id:itemNull
    width: 120
    height: 150
    property string netStateValue: ResourcesModel.networkState
    property string preState : "2"

    signal deviceNetworkStateChanged(var state)

    Kirigami.Icon {
        id: nullImage
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/img/nullpage.png"
        width:60 * appScaleSize
        height: 60 * appScaleSize
        color: Kirigami.JTheme.majorForeground
    }

    Text {
        id: nullText
        anchors {
            top: nullImage.bottom
            horizontalCenter: nullImage.horizontalCenter
        }
        text: getShowText()
        font.pixelSize: defaultFontSize
        color: Kirigami.JTheme.disableForeground
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
            return i18n("There is no app at present")
        }
    }
}
