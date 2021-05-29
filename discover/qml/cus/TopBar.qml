

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1

Rectangle {
    property var textCont
    signal backClicked
    anchors.top: parent.top
    width: parent.width
    color: "transparent"

    RowLayout {

        Image {
            id: img_back
            Layout.preferredWidth: 22 * appScaleSize
            Layout.preferredHeight: 22 * appScaleSize
            source: "qrc:/img/ic_back.png"
            sourceSize: Qt.size(40, 40)
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
            color: '#FF000000'
            font {
                pixelSize: discoverMain.defaultFontSize + 6
                bold: true
            }
        }
    }
}
