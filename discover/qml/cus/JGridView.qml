

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami

GridView {
    id: root
    property Component component
    readonly property int columns: 3
    property int gridSpacing: 13 * appScaleSize
    property int maximumColumns: Infinity
    property int maximumColumnWidth: Kirigami.Units.gridUnit * 20
    property int minimumColumnWidth: Kirigami.Units.gridUnit * 12

    Layout.fillWidth: true
    cellWidth: Math.floor(width / columns)
    cellHeight: Math.max(Kirigami.Units.gridUnit * 15,
                         Math.min(cellWidth, maximumColumnWidth) / 1.2)
    delegate: Kirigami.DelegateRecycler {
        sourceComponent: component
        width: root.cellWidth - gridSpacing
        height: root.cellHeight - gridSpacing
    }
    ScrollBar.vertical: ScrollBar {
        active: true
    }
}
