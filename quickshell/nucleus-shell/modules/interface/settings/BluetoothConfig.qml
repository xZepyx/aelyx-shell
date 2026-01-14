import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules.widgets
import qs.modules.functions
import qs.services
import Quickshell.Bluetooth as QsBluetooth

ContentMenu {
    title: "Bluetooth"
    description: "Manage Bluetooth devices and connections."


    ContentCard {
        ContentRowCard {
            cardSpacing: 0
            verticalPadding: Bluetooth.defaultAdapter.enabled ? 10 : 0
            cardMargin: 0

            StyledText {
                text: powerSwitch.checked ? "Power: On" : "Power: Off"
                font.pixelSize: 16
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            StyledSwitch {
                id: powerSwitch
                checked: Bluetooth.defaultAdapter?.enabled
                onToggled: Bluetooth.defaultAdapter.enabled = checked
            }
        }

        ContentRowCard {
            visible: Bluetooth.defaultAdapter.enabled
            cardSpacing: 0
            verticalPadding: 10
            cardMargin: 0

            ColumnLayout {
                spacing: 2

                StyledText {
                    text: "Discoverable"
                    font.pixelSize: 16
                }

                StyledText {
                    text: "Allow other devices to find this computer."
                    font.pixelSize: 12
                    color: ColorUtils.transparentize(Appearance.m3colors.m3onSurface, 0.6)
                }
            }

            Item { Layout.fillWidth: true }

            StyledSwitch {
                checked: Bluetooth.defaultAdapter?.discoverable
                onToggled: Bluetooth.defaultAdapter.discoverable = checked
            }
        }

        ContentRowCard {
            visible: Bluetooth.defaultAdapter.enabled
            cardSpacing: 0
            verticalPadding: 0
            cardMargin: 0

            ColumnLayout {
                spacing: 2

                StyledText {
                    text: "Scanning"
                    font.pixelSize: 16
                }

                StyledText {
                    text: "Search for nearby Bluetooth devices."
                    font.pixelSize: 12
                    color: ColorUtils.transparentize(Appearance.m3colors.m3onSurface, 0.6)
                }
            }

            Item { Layout.fillWidth: true }

            StyledSwitch {
                checked: Bluetooth.defaultAdapter?.discovering
                onToggled: Bluetooth.defaultAdapter.discovering = checked
            }
        }
    }

    ContentCard {
        visible: connectedDevices.count > 0

        StyledText {
            text: "Connected Devices"
            font.pixelSize: 18
            font.bold: true
        }

        Repeater {
            id: connectedDevices
            model: Bluetooth.devices.filter(d => d.connected)

            delegate: BluetoothDeviceCard {
                device: modelData
                statusText: modelData.batteryAvailable
                    ? "Connected, " + Math.floor(modelData.battery * 100) + "% left"
                    : "Connected"
                showDisconnect: true
                showRemove: true
                usePrimary: true
            }
        }
    }

    ContentCard {
        visible: Bluetooth.defaultAdapter?.enabled

        StyledText {
            text: "Paired Devices"
            font.pixelSize: 18
            font.bold: true
        }

        Item {
            visible: pairedDevices.count === 0
            width: parent.width
            height: 40

            StyledText {
                anchors.left: parent.left
                text: "No paired devices"
                font.pixelSize: 14
                color: ColorUtils.transparentize(Appearance.m3colors.m3onSurface, 0.6)
            }
        }

        Repeater {
            id: pairedDevices
            model: Bluetooth.devices.filter(d => !d.connected && d.paired)

            delegate: BluetoothDeviceCard {
                device: modelData
                statusText: "Not connected"
                showConnect: true
                showRemove: true
            }
        }
    }

    ContentCard {
        visible: Bluetooth.defaultAdapter?.enabled

        StyledText {
            text: "Available Devices"
            font.pixelSize: 18
            font.bold: true
        }

        Item {
            visible: discoveredDevices.count === 0 && !Bluetooth.defaultAdapter.discovering
            width: parent.width
            height: 40

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: "No new devices found"
                font.pixelSize: 14
                color: ColorUtils.transparentize(Appearance.m3colors.m3onSurface, 0.6)
            }
        }

        Repeater {
            id: discoveredDevices
            model: Bluetooth.devices.filter(d => !d.paired && !d.connected)

            delegate: BluetoothDeviceCard {
                device: modelData
                statusText: "Discovered"
                showConnect: true
                showPair: true
            }
        }
    }
}
