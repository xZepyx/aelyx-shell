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

    readonly property bool wifiConnected: Network.connectedSsid !== "No Internet"
    readonly property string networkstatustext: wifiConnected ? Network.connectedSsid : "Disabled"

    property string networkstatusicon: {
        if (!wifiConnected)
            return "signal_wifi_off";
        if (Network.signalStrength > 60)
            return "network_wifi";
        if (Network.signalStrength > 30)
            return "network_wifi_2_bar";
        return "network_wifi_1_bar";
    }

    Process {
        id: toggleWifiProc
        running: false
        command: []

        function toggle() {
            const cmd = wifiConnected ? "off" : "on";
            toggleWifiProc.command = ["bash", "-c", `nmcli radio wifi ${cmd}`];
            toggleWifiProc.running = true;
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
        color: !wifiConnected ? Appearance.m3colors.m3surfaceContainerHigh : Appearance.m3colors.m3primaryContainer

        MaterialSymbol {
            anchors.centerIn: parent
            iconSize: 35
            icon: networkstatusicon
        }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBg.right
        anchors.leftMargin: 10

        StyledText {
            text: "Network"
            font.pixelSize: 20
        }

        StyledText {
            text: networkstatustext
            font.pixelSize: Appearance.font.size.small
        }
    }

    // Whole card toggles WiFi radio
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: toggleWifiProc.toggle()
    }
}
