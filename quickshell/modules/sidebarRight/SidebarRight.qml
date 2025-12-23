import qs.settings
import qs.widgets
import qs.services
import qs.functions
import qs.modules.sidebarRight.widgets
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: sidebarRight
    WlrLayershell.layer: WlrLayer.Top
    visible: Shell.ready && GlobalStates.sidebarRightOpen

    color: "transparent"
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor


    property real sidebarRightWidth: 500

    implicitWidth: sidebarRightWidth

    anchors {
        top: true
        left: Shell.flags.bar.modules.bluetoothWifi.position === "left"
        right: Shell.flags.bar.modules.bluetoothWifi.position === "right" 
        bottom: true
    }

    margins {
        top: 20
        bottom: 20
        left: Appearance.margin.large
        right: Appearance.margin.large
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink?.audio


    StyledRect {
        id: container
        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.normal
        implicitWidth: sidebarRight.sidebarRightWidth

        anchors.fill: parent

        Item {
            anchors.fill: parent
            anchors.leftMargin: Appearance.margin.large
            anchors.rightMargin: Appearance.margin.small
            anchors.topMargin: Appearance.margin.large
            anchors.bottomMargin: Appearance.margin.large

            ColumnLayout {
                id: mainLayout
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Appearance.margin.tiny
                anchors.rightMargin: Appearance.margin.small
                anchors.topMargin: Shell.flags.bar.atTop ? Appearance.margin.small : 0
                anchors.bottomMargin: !Shell.flags.bar.atTop ? Appearance.margin.small : 0
                anchors.margins: Appearance.margin.large
                spacing: Appearance.margin.large

                // --- Top Section ---
                RowLayout {
                    id: topSection
                    Layout.fillWidth: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 2

                        RowLayout {
                            spacing: 8

                            StyledText {
                                text: SystemDetails.osIcon
                                font.pixelSize: Appearance.font.size.hugeass + 6
                            }

                            StyledText {
                                text: SystemDetails.uptime
                                font.pixelSize: Appearance.font.size.large
                                Layout.alignment: Qt.AlignBottom 
                                Layout.bottomMargin: 5
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Row {
                        spacing: 6
                        Layout.leftMargin: 25
                        Layout.alignment: Qt.AlignVCenter 
                        StyledRect {
                            id: editbtncontainer
                            color: "transparent"
                            radius: Appearance.rounding.large
                            implicitHeight: editButton.height + Appearance.margin.tiny
                            implicitWidth: editButton.width + Appearance.margin.small
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.topMargin: 10
                            Layout.leftMargin: 15

                            MaterialSymbolButton {
                                id: editButton
                                icon: "edit"
                                anchors.centerIn: parent
                                iconSize: Appearance.font.size.hugeass + 2

                                onButtonClicked: {
                                    Quickshell.execDetached(["hyprpicker"])
                                    GlobalStates.sidebarRightOpen = false;
                                }
                            }
                        }
                        StyledRect {
                            id: reloadbtncontainer
                            color: "transparent"
                            radius: Appearance.rounding.large
                            implicitHeight: reloadButton.height + Appearance.margin.tiny
                            implicitWidth: reloadButton.width + Appearance.margin.small
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.topMargin: 10
                            Layout.leftMargin: 15

                            MaterialSymbolButton {
                                id: reloadButton
                                icon: "refresh"
                                anchors.centerIn: parent
                                iconSize: Appearance.font.size.hugeass + 4

                                onButtonClicked: {
                                    Quickshell.execDetached(["bash", "-c", "~/.local/share/aelyx/scripts/system/reloadSystem.sh"])
                                }
                            }
                        }
                        StyledRect {
                            id: settingsbtncontainer
                            color: "transparent"
                            radius: Appearance.rounding.large
                            implicitHeight: settingsButton.height + Appearance.margin.tiny
                            implicitWidth: settingsButton.width + Appearance.margin.small
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.topMargin: 10
                            Layout.leftMargin: 15

                            MaterialSymbolButton {
                                id: settingsButton
                                icon: "settings"
                                anchors.centerIn: parent
                                iconSize: Appearance.font.size.hugeass + 2

                                onButtonClicked: {
                                    GlobalStates.sidebarRightOpen = false
                                    GlobalStates.visible_settingsMenu = true
                                }
                            }
                        }
                        StyledRect {
                            id: powerbtncontainer
                            color: "transparent"
                            radius: Appearance.rounding.large
                            implicitHeight: settingsButton.height + Appearance.margin.tiny
                            implicitWidth: settingsButton.width + Appearance.margin.small
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.topMargin: 10
                            Layout.leftMargin: 15

                            MaterialSymbolButton {
                                id: powerButton
                                icon: "power_settings_new"
                                anchors.centerIn: parent
                                iconSize: Appearance.font.size.hugeass + 2

                                onButtonClicked: {
                                    GlobalStates.sidebarRightOpen = false
                                    GlobalStates.powerMenuOpen = true
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Appearance.m3colors.m3outlineVariant
                    radius: 1
                }

                ColumnLayout {
                    id: sliderColumn
                    Layout.fillWidth: true

                    Volume {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        icon: "volume_up"
                        iconSize: Appearance.font.size.large + 3
                    }

                    Brightness {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        icon: "brightness_high"
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Appearance.m3colors.m3outlineVariant
                    radius: 1
                }

                GridLayout {
                    id: middleGrid
                    Layout.fillWidth: true
                    columns: 1
                    columnSpacing: 8
                    rowSpacing: 8

                    // Make all items stretch equally
                    Layout.preferredWidth: parent.width

                    RowLayout {
                        Network {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                        }
                        FlightMode {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                        }

                    }

                    RowLayout {
                        Bluetooth {
                            Layout.preferredWidth: 220
                            Layout.preferredHeight: 80                      
                        }
                        Interface {
                            Layout.preferredHeight: 80
                            Layout.fillWidth: true
                        }
                        NightTime {
                            Layout.preferredHeight: 80
                            Layout.fillWidth: true
                        }

                    }
                }

                ColumnLayout {
                    spacing: Appearance.margin.small
                    
                    Layout.fillWidth: true


                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Appearance.m3colors.m3outlineVariant
                        radius: 1
                        Layout.topMargin: 10
                        Layout.bottomMargin: 20
                    }

                    NotifModal{
                        Layout.preferredHeight: 430
                    }

                }
            }
        }
    }

    // --- Toggle logic ---
    function togglesidebarRight() {
        const newState = !GlobalStates.sidebarRightOpen
        GlobalStates.sidebarRightOpen = newState
        if (newState)
            sidebarRight.forceActiveFocus()
        else
            sidebarRight.focus = false
    }

    IpcHandler {
        target: "sidebarRight"
        function toggle() {
            togglesidebarRight()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            sidebarRight.monitor = Hyprland.focusedMonitor
        }
    }
}
