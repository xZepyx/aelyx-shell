import qs.config
import qs.widgets
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts

Rectangle {
    id: root
    width: 200
    height: 80
    radius: Appearance.rounding.verylarge
    color: Appearance.m3colors.m3paddingContainer

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    Layout.margins: 0

    readonly property bool isDark: Config.options.appearance.theme === "dark"
    readonly property string themestatustext: isDark ? "Dark Theme" : "Light Theme"
    property string themestatusicon: isDark ? "dark_mode" : "light_mode"

    Rectangle {
        id: iconBg
        width: 50
        height: 50
        radius: 25
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        color: Appearance.m3colors.m3paddingContainer

        MaterialSymbol {
            anchors.centerIn: parent
            iconSize: 35
            icon: themestatusicon
        }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBg.right
        anchors.leftMargin: 10

        StyledText {
            text: "Interface"
            font.pixelSize: 20
        }

        StyledText {
            text: themestatustext
            font.pixelSize: Appearance.font.size.small
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Quickshell.execDetached(["qs", "ipc", "call", "global", "toggleTheme"])
        }
    }
}
