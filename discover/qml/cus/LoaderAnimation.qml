
/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.0

Rectangle {
    property alias timerRun: animLoader.active
    property int updateIndex

    color: "#E8EFFF"

    Component {
        id: animComponment
        
        AnimatedImage {
            asynchronous: true
            width: 50
            height: 50
            source: "qrc:/img/loadanim.gif"
        }
    }

    Loader {
        id: animLoader

        sourceComponent: animComponment
        anchors.centerIn: parent
    }
}
