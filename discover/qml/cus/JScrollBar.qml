import QtQuick 2.7
import QtQuick.Controls 2.15
import org.kde.kirigami 2.9 as Kirigami

ScrollBar {
    property var visibility
    property var zv
    z: zv
    visible: visibility
    interactive: !Kirigami.Settings.hasTransientTouchInput
    opacity: active ? 1 : 0
    // active: hovered || pressed || moving

    //NOTE: use this instead of anchors as crashes on some Qt 5.8 checkouts
    height: parent.height
    anchors {
        right: parent.right
        top: parent.top
        topMargin: 20
    }
}