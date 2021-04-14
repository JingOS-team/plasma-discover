/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

RowLayout {
    Layout.preferredHeight:20
    Image {
        Layout.preferredWidth:50
        Layout.preferredHeight:50
        source:icon
    }

    Label {
        text:name
    }
}