import qs.settings
import qs.widgets
import qs.services
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Bluetooth

StyledRect {
    id: root
    width: 200
    height: 80
    radius: Appearance.rounding.verylarge + 5

    // Enabled = BT adapter on
    property bool btEnabled: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false
    property string btState: btEnabled ? "Enabled" : "Disabled"
    property string connectedDeviceId: "Connected"

    Timer {
        interval: 10000
        repeat: true 
        running: true 
        onTriggered: btNameProc.running = true
    }

    Process {
        id: btNameProc
        running: true
        command: ["sh", "-c", "bluetoothctl info | grep 'Name' | awk -F ': ' '{print $2}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                var deviceName = text.trim()
                root.connectedDeviceId = deviceName
            }
        }
    }

    readonly property string btstatustext: (btEnabled && connectedDeviceId != "") ? connectedDeviceId : btState
    property string btstatusicon: btEnabled ? "bluetooth" : "bluetooth_disabled"

    // Match Network & Theme tile colors
    color: Appearance.m3colors.m3surfaceContainerHigh

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    Layout.margins: 0

    Process {
        id: adapterWarn
        command: ["notify-send", "No Bluetooth adapter found!"]
    }

    function toggleBluetooth() {
        const adapter = Bluetooth.defaultAdapter;
        if (!adapter) {
            adapterWarn.running = true;
            return;
        }
        adapter.enabled = !adapter.enabled;
        btEnabled = adapter.enabled;
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
        color: !btEnabled ? Appearance.m3colors.m3surfaceContainerHigh : Appearance.m3colors.m3primaryContainer

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

    MouseArea {
        anchors.fill: parent
        onClicked: toggleBluetooth()
    }
}
