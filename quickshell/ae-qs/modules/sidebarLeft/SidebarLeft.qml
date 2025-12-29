import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtCore
import qs.functions
import qs.services
import qs.settings
import qs.widgets

PanelWindow {
    id: sidebarLeft

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor
    property real sidebarLeftWidth: 500

    // --- Toggle logic ---
    function togglesidebarLeft() {
        const newState = !GlobalStates.sidebarLeftOpen;
        GlobalStates.sidebarLeftOpen = newState;
    }

    WlrLayershell.layer: WlrLayer.Top
    visible: Shell.ready && GlobalStates.sidebarLeftOpen
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: sidebarLeftWidth

    anchors {
        top: true
        left: true
        bottom: true
    }

    margins {
        top: 10
        bottom: 10
        left: Appearance.margin.small
    }

    StyledRect {
        id: container

        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.normal
        implicitWidth: sidebarLeft.sidebarLeftWidth
        anchors.fill: parent

        SidebarLeftContent{}

    }

    IpcHandler {
        function toggle() {
            togglesidebarLeft();
        }

        target: "sidebarLeft"
    }

    Connections {
        function onFocusedMonitorChanged() {
            sidebarLeft.monitor = Hyprland.focusedMonitor;
        }

        target: Hyprland
    }

}
