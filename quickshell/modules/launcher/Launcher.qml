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
    id: launcher
    WlrLayershell.layer: WlrLayer.Top
    visible: Shell.ready && GlobalStates.launcherOpen
    WlrLayershell.keyboardFocus: GlobalStates.launcherOpen


    color: "transparent"
    exclusiveZone: 0

    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1

    property real launcherWidth: screenW * 0.29 / scale
    property real launcherHeight: screenH * 0.66 / scale

    implicitWidth: launcherWidth
    implicitHeight: launcherHeight

    anchors {
        top: true
        right: false 
        left: false
        bottom: false
    }

    margins {
        top: monitor.height / 8
        bottom: monitor.height / 8
        left: Appearance.margin.large
        right: Appearance.margin.large
    }


    StyledRect {
        id: container
        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.verylarge
        implicitWidth: launcher.launcherWidth

        anchors.fill: parent

        LauncherContent {}
        
    }

    // --- Toggle logic ---
    function togglelauncher() {
        const newState = !GlobalStates.launcherOpen
        GlobalStates.launcherOpen = newState
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            togglelauncher()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            launcher.monitor = Hyprland.focusedMonitor
        }
    }
}
