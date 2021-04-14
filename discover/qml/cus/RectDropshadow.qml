

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: installBg

    property int rectRadius
    property string shadowColor: "#80C3C9D9"
    border {
        width: 1
        color: "#C7D3DBEE"
    }
    color: "#F2FBFBFB"
    radius: height / 5
    layer.enabled: true
    layer.effect: DropShadow {
        id: rectShadow
        
        anchors.fill: installBg
        color: shadowColor
        source: installBg
        samples: 9
        radius: 4
        horizontalOffset: 0
        verticalOffset: 0
        spread: 0
    }
}
