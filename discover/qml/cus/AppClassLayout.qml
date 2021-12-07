/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
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
