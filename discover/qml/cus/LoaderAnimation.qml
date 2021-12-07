/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
import QtQuick 2.0
import org.kde.kirigami 2.15 as Kirigami

Rectangle {
    property alias timerRun: animLoader.active
    property int updateIndex

    color: Kirigami.JTheme.background

    Component {
        id: animComponment
        AnimatedImage {
            asynchronous: true
            width: 25 * appScaleSize
            height: 25 * appScaleSize
            source: discoverMain.isDarkTheme ? "qrc:/img/black_load.gif" : "qrc:/img/loadanim.gif"
        }
    }

    Loader {
        id: animLoader
        sourceComponent: animComponment
        anchors.centerIn: parent
    }
}
