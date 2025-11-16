import qs.config
import qs.widgets
import qs.services
import qs.modules.controlCenter.widgets
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: controlCenter
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.ready

    color: "transparent"
    focusable: true
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor


    property real controlCenterWidth: 520
    property real controlCenterHeight: 640

    implicitWidth: controlCenterWidth
    implicitHeight: controlCenterHeight

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    function shortText(str, len = 25) {
        if (!str)
            return ""
        return str.length > len ? str.slice(0, len) + "" : str
    }

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
    }

    mask: Region {
        item: overlay
        intersection: SessionState.controlCenterOpen ? Intersection.Combine : Intersection.Xor
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink?.audio

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "transparent"
        opacity: SessionState.controlCenterOpen ? 1 : 0
        Behavior on opacity { Anim {} }

        MouseArea {
            anchors.fill: parent
            enabled: SessionState.controlCenterOpen
            onClicked: SessionState.controlCenterOpen = false
        }
    }

    MergedEdgeRect {
        id: container
        visible: implicitHeight > 0
        color: Appearance.m3colors.m3background
        cornerRadius: Appearance.rounding.verylarge
        implicitWidth: controlCenter.controlCenterWidth
        implicitHeight: SessionState.controlCenterOpen ? controlCenter.controlCenterHeight : 0

        Behavior on implicitHeight { Anim {} }

        anchors {
            right: parent.right
            rightMargin: Config.options.background.borderEnabled ? Appearance.margin.tiny + 2 : 0
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        states: [
            State {
                name: "ccAtBottom"
                when: Config.options.bar.position === 2
                AnchorChanges {
                    target: container
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "ccAtTop"
                when: Config.options.bar.position === 1
                AnchorChanges {
                    target: container
                    anchors.bottom: undefined
                    anchors.top: parent.top
                }
            }
        ]
        content: Item {
            anchors.fill: parent
            opacity: SessionState.controlCenterOpen ? 1 : 0
            Behavior on opacity { Anim {} }

            ColumnLayout {
                id: mainLayout
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Appearance.margin.tiny
                anchors.rightMargin: Appearance.margin.small
                anchors.topMargin: Config.options.bar.position === 1 ? Appearance.margin.large : 0
                anchors.bottomMargin: Config.options.bar.position === 2 ? Appearance.margin.large : 0
                anchors.margins: Appearance.margin.large
                spacing: Appearance.margin.large

                // --- Top Section ---
                RowLayout {
                    Layout.fillWidth: true

                    ProfilePicture {}

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 2

                        StyledText { 
                            text: SystemDetails.username 
                            font.pixelSize: Appearance.font.size.wildass - 6
                        }

                        RowLayout {
                            spacing: 8

                            StyledText {
                                text: SystemDetails.osIcon
                                font.pixelSize: Appearance.font.size.huge
                            }

                            StyledText {
                                text: SystemDetails.uptime
                                font.pixelSize: Appearance.font.size.normal
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Column {
                        spacing: 6
                        Layout.leftMargin: 25
                        Layout.alignment: Qt.AlignVCenter 
                        StyledRect {
                            id: powerbtncontainer
                            color: Appearance.m3colors.m3paddingContainer
                            radius: Appearance.rounding.normal
                            implicitHeight: settingsButton.height + Appearance.margin.tiny
                            implicitWidth: settingsButton.width + Appearance.margin.small
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.topMargin: 10
                            Layout.leftMargin: 15

                            MaterialSymbolButton {
                                id: powerButton
                                icon: "power_settings_new"
                                anchors.centerIn: parent
                                iconSize: Appearance.font.size.wildass - 10

                                onButtonClicked: {
                                    SessionState.controlCenterOpen = false
                                    SessionState.powerMenuOpen = true
                                }
                            }
                        }
                        StyledRect {
                            id: settingsbtncontainer
                            color: Appearance.m3colors.m3paddingContainer
                            radius: Appearance.rounding.normal
                            implicitHeight: settingsButton.height + Appearance.margin.tiny
                            implicitWidth: settingsButton.width + Appearance.margin.small
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.topMargin: 10
                            Layout.leftMargin: 15

                            MaterialSymbolButton {
                                id: settingsButton
                                icon: "settings"
                                anchors.centerIn: parent
                                iconSize: Appearance.font.size.wildass - 10

                                onButtonClicked: {
                                    SessionState.controlCenterOpen = false
                                    SessionState.visible_settingsMenu = true
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

                // --- Bottom Grid Section (right under the separator) ---
                GridLayout {
                    id: middleGrid
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: Appearance.margin.large
                    rowSpacing: Appearance.margin.large

                    // Make all items stretch equally
                    Layout.preferredWidth: parent.width

                    Network {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                    }
                    Bluetooth {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                    }
                    Notifications {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80                    
                    }
                    Interface {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80                         
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Appearance.m3colors.m3outlineVariant
                    radius: 1
                }

                ColumnLayout {
                    spacing: Appearance.margin.small
                    
                    Layout.fillWidth: true

                    RowLayout {
                        StyledText {
                            Layout.alignment: Qt.AlignLeft
                            text: "Volume"
                        }

                        Item { Layout.fillWidth: true }

                        StyledText {
                            animate: false
                            text: Math.round(sink ? sink.volume * 100 : 0) + "%"
                            Layout.alignment: Qt.AlignRight
                        }
                    }

                    ColumnLayout {
                        id: bottomColumn
                        Layout.fillWidth: true

                        Volume {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                        }

                        RowLayout {

                            StyledText {
                                Layout.alignment: Qt.AlignLeft
                                text: "Brightness"
                            }

                            Item { Layout.fillWidth: true }

                            StyledText {
                                animate: false
                                property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null
                                text: Math.round(monitor.brightness * 100) + "%"
                                Layout.alignment: Qt.AlignRight
                            }
                        }

                        Brightness {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                        }
                    }
                }
            }
        }
    }

    // --- Toggle logic ---
    function togglecontrolCenter() {
        const newState = !SessionState.controlCenterOpen
        SessionState.controlCenterOpen = newState
        if (newState)
            controlCenter.forceActiveFocus()
        else
            controlCenter.focus = false
    }

    IpcHandler {
        target: "controlCenter"
        function toggle() {
            togglecontrolCenter()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            controlCenter.monitor = Hyprland.focusedMonitor
        }
    }
}
