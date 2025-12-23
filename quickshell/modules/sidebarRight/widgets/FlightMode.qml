import qs.settings
import qs.widgets
import qs.functions
import qs.services
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts

StyledRect {
    id: root
    width: 150
    height: 50
    radius: Appearance.rounding.verylarge + 5
    color: Appearance.m3colors.m3surfaceContainerHigh

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    property bool flightMode
    property string flightModeText: flightMode ? "Enabled" : "Disabled"

    Process {
        id: toggleflightModeProc
        running: false
        command: []

        function toggle() {
            flightMode = !flightMode;
            const cmd = flightMode ? "off" : "on";
            toggleflightModeProc.command = ["bash", "-c", `nmcli radio all ${cmd}`];
            toggleflightModeProc.running = true;
        }
    }

    // Icon background
    StyledRect {
        id: iconBg
        width: 50
        height: 50
        radius: Appearance.rounding.large
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        color: !flightMode ? Appearance.m3colors.m3surfaceContainerHigh : Appearance.m3colors.m3primaryContainer

        MaterialSymbol {
            anchors.centerIn: parent
            iconSize: 35
            icon: "flight"
        }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBg.right
        anchors.leftMargin: 10

        StyledText {
            text: "Flight Mode"
            font.pixelSize: 20
        }

        StyledText {
            text: flightModeText
            font.pixelSize: Appearance.font.size.small
        }
    }

    // Whole card toggles flightMode radio
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: toggleflightModeProc.toggle()
    }
}
