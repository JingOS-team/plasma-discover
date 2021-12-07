/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.15 as Kirigami

Rectangle {
    property var textCont
    signal backClicked
    anchors.top: parent.top
    width: parent.width
    color: "transparent"

    RowLayout {

        Kirigami.Icon {
            id: img_back
            Layout.preferredWidth: 22 * appScaleSize
            Layout.preferredHeight: 22 * appScaleSize
            source: "qrc:/img/ic_back.png"
            color: Kirigami.JTheme.majorForeground
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    backClicked()
                }
            }
        }
        Label {
            text: textCont
            anchors {
                verticalCenter: img_back.verticalCenter
                leftMargin: 17
            }
            color: Kirigami.JTheme.majorForeground//'#FF000000'
            font {
                pixelSize: discoverMain.defaultFontSize + 6 * appFontSize
                bold: true
            }
        }
    }
}
