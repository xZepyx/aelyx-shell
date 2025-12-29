import qs.settings
import qs.widgets
import qs.services
import qs.functions
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
        right: true
        bottom: true
    }

    margins {
        top: 10
        bottom: 10
        right: Appearance.margin.small
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

        SidebarRightContent{}

    }

    // --- Toggle logic ---
    function togglesidebarRight() {
        const newState = !GlobalStates.sidebarRightOpen
        GlobalStates.sidebarRightOpen = newState
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
