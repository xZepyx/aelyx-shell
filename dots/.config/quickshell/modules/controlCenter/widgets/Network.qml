import qs.core.appearance
import qs.core.config
import qs.common.widgets
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
    color: wifiConnected ? Appearance.m3colors.m3onSecondary : Appearance.m3colors.m3paddingContainer

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
        id: manageConnections
        command: ["bash", "-c", "foot nmtui"]
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
        radius: Appearance.rounding.verylarge
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        color: root.color

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: false
            onClicked: {
                manageConnections.running = true;
                Config.ccVisible = false;
            }

            onEntered: root.networkstatusicon = "network_manage"
            onExited: root.networkstatusicon = wifiConnected
                ? (Network.signalStrength > 60 ? "network_wifi" :
                  Network.signalStrength > 30 ? "network_wifi_2_bar" : "network_wifi_1_bar")
                : "signal_wifi_off"
        }

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
