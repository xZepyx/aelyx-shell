import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.settings
import qs.widgets

Rectangle {
    id: root

    readonly property bool isDark: Shell.flags.appearance.theme === "dark"
    property string themestatusicon: isDark ? "dark_mode" : "light_mode"

    width: 200
    height: 80
    radius: Appearance.rounding.verylarge + 20
    color: Appearance.m3colors.m3paddingContainer
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    Layout.margins: 0

    MaterialSymbol {
        anchors.centerIn: parent
        iconSize: 35
        icon: themestatusicon
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Quickshell.execDetached(["qs", "ipc", "call", "global", "toggleTheme"]);
        }
    }

}
