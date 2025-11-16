import qs.config 
import qs.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: launcher
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: SessionState.launcherOpen
    visible: Config.ready

    color: "transparent"
    focusable: true
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1

    property real launcherWidth: screenW * 0.33 / scale
    property real launcherHeight: screenH * 0.69 / scale

    implicitWidth: launcherWidth
    implicitHeight: launcherHeight

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
    }

    mask: Region {
        item: overlay
        intersection: SessionState.launcherOpen ? Intersection.Combine : Intersection.Xor
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "transparent"

        Behavior on opacity { Anim {} }

        MouseArea {
            anchors.fill: parent
            enabled: SessionState.launcherOpen
            onClicked: {
                container.searchQuery = ""
                SessionState.launcherOpen = false
            }
        }
    }

    MergedEdgeRect { 
        id: container
        visible: implicitHeight > 0
        color: Appearance.m3colors.m3background
        cornerRadius: Appearance.rounding.verylarge
        implicitWidth: SessionState.launcherOpen ? launcher.launcherWidth : 0
        implicitHeight: SessionState.launcherOpen ? launcher.launcherHeight : 0
        opacity: SessionState.launcherOpen ? 1 : 0

        Behavior on implicitHeight { Anim {} }
        Behavior on implicitWidth { Anim {} }
        Behavior on opacity { Anim {} }

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottomMargin: (Config.options.bar.style === 2 ? 14 : 0) 
            topMargin: (Config.options.bar.style === 2 ? 14 : 0)
            verticalCenter: parent.verticalCenter
        }

        content: LauncherContent {}
    }

    // Ah let me guess you're probably thinking why did
    // I use mergededgerect even though its not merged its just looks better than rect.


    function toggleLauncher() {
        SessionState.launcherOpen = !SessionState.launcherOpen
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            toggleLauncher()
        }
    }

    // --- Update when Hyprland changes the focused monitor ---
    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            launcher.monitor = Hyprland.focusedMonitor
        }
    }
}
