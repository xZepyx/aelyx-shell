import qs.config
import qs.widgets
import qs.services
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts

StyledRect {
    id: root
    width: 200
    height: 80
    radius: Appearance.rounding.verylarge

    // Active state = Focus Mode ON
    property bool isActive: false
    readonly property string themestatustext: isActive ? "Active" : "Inactive"
    property string themestatusicon: isActive ? "do_not_disturb_on" : "do_not_disturb_off"

    color: isActive ? Appearance.m3colors.m3onSecondary
                    : Appearance.m3colors.m3paddingContainer

    // Grid friendly
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    Process {
        id: toggleDnd
        running: false
        command: []

        function toggle() {
            const cmd = isActive ? "-dn" : "-df";
            toggleDnd.command = ["swaync-client", cmd];
            toggleDnd.running = true;
            root.isActive = !root.isActive;
        }
    }

    // Icon background
    StyledRect {
        id: iconBg
        width: 50
        height: 50
        radius: 25
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Appearance.margin.small

        color: root.color

        MouseArea {
            anchors.fill: parent
            onClicked: toggleDnd.toggle()
        }

        MaterialSymbol {
            anchors.centerIn: parent
            icon: themestatusicon
            iconSize: 35
        }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBg.right
        anchors.leftMargin: Appearance.margin.small

        StyledText {
            text: "Focus Mode"
            font.pixelSize: Appearance.font.size.large
        }

        StyledText {
            text: themestatustext
            font.pixelSize: Appearance.font.size.small
        }
    }

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: toggleDnd.toggle()
    }
}
