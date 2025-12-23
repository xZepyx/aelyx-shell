import qs.settings
import qs.modules.bar
import qs.widgets
import qs.services
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import QtQuick.Layouts

BarModule {
    id: root
    Layout.alignment: Qt.AlignVCenter

    // let layout compute size
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    StyledRect {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius

        implicitWidth: contentRow.implicitWidth + Appearance.margin.large - 5
        implicitHeight: contentRow.implicitHeight + Appearance.margin.small - 5

        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            spacing: 14

            // --- Network --- /
            MaterialSymbol {
                id: wifi
                icon: {
                    const s = Network.signalStrength;
                    if (s > 80)
                        return "network_wifi_3_bar";
                    if (s > 60)
                        return "network_wifi_2_bar";
                    if (s > 40)
                        return "network_wifi_1_bar";
                    return "network_wifi_1_bar";
                }
                iconSize: Appearance.font.size.huge 
            }
            // --- Bluetooth ---

            MaterialSymbol {
                id: btIcon
                icon: "bluetooth"
                iconSize: Appearance.font.size.huge
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen
            }
        }
    }

    // --- Bluetooth status updates ---
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: updateIcon()
    }

    function updateIcon() {
        const adapter = Bluetooth.defaultAdapter;
        if (!adapter) {
            btIcon.text = "bluetooth_disabled";
            return;
        }
        const connectedDevice = adapter.devices.values.find(d => d.connected);
        btIcon.text = connectedDevice ? "bluetooth_connected" : "bluetooth";
    }

    Component.onCompleted: updateIcon()
}
