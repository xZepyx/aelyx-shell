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

    // Enabled = BT adapter on
    property bool btEnabled: Bluetooth.enabled

    readonly property string btstatustext: btEnabled ? Bluetooth.connectedDeviceId : "Disabled"
    property string btstatusicon: btEnabled ? "bluetooth" : "bluetooth_disabled"

    // Match Network & Theme tile colors
    color: btEnabled ? Appearance.m3colors.m3onSecondary
                     : Appearance.m3colors.m3paddingContainer

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    Layout.margins: 0

    Process {
        id: adapterWarn
        command: ["notify-send", "No Bluetooth adapter found!"]
    }

    Process {
        id: togglebtProc
        running: false
        command: []

        function toggle() {
            const adapter = Bluetooth.adapter;
            if (!adapter) {
                adapterWarn.running = true;
                return;
            }

            adapter.enabled = !adapter.enabled;
            btEnabled = adapter.enabled;
        }
    }

    // --- Icon Circle ---
    StyledRect {
        id: iconBg
        width: 50
        height: 50
        radius: Appearance.rounding.verylarge
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Appearance.margin.small
        color: root.color   // SAME as parent for unified look

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: togglebtProc.toggle()

            onEntered: root.btstatusicon = "settings_bluetooth"
            onExited: root.btstatusicon = btEnabled ? "bluetooth" : "bluetooth_disabled"
        }

        MaterialSymbol {
            anchors.centerIn: parent
            iconSize: 35
            icon: btstatusicon
        }
    }

    // --- Text Column ---
    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBg.right
        anchors.leftMargin: Appearance.margin.small

        StyledText {
            text: "Bluetooth"
            font.pixelSize: Appearance.font.size.large
        }

        StyledText {
            text: btstatustext
            font.pixelSize: Appearance.font.size.small
        }
    }

    // Whole tile toggle
    MouseArea {
        anchors.fill: parent
        onClicked: togglebtProc.toggle()
    }
}
