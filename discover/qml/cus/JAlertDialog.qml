

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.12
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2

Kirigami.JDialog {
    id: dialog

    property var titleContent: "Uninstall"
    property var msgContent: "Are you sure uninstall the app?"
    property var rightButtonContent: "Uninstall"
    property var leftButtonContent: "Cancel"

    signal dialogRightClicked
    signal dialogLeftClicked

    title: titleContent
    text: msgContent
    rightButtonText: qsTr(rightButtonContent)
    leftButtonText: qsTr(leftButtonContent)
    visible: false

    onVisibleChanged: {
        if (!visible) {
            albumView.rightMenuPhoto = false
            albumView.rightMenuVideo = false
        }
    }

    onRightButtonClicked: {
        dialogRightClicked()
    }

    onLeftButtonClicked: {
        dialogLeftClicked()
    }
}
