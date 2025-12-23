import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import qs.functions
import qs.services
import qs.settings
import qs.widgets

PanelWindow {
    id: powerMenu

    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1
    property real powerMenuWidth: screenW * 0.25/ scale
    property real powerMenuHeight: screenH * 0.30 / scale

    // --- Toggle logic ---
    function togglepowerMenu() {
        const newState = !GlobalStates.powerMenuOpen;
        GlobalStates.powerMenuOpen = newState;
        if (newState)
            powerMenu.forceActiveFocus();
        else
            powerMenu.focus = false;
    }

    WlrLayershell.layer: WlrLayer.Top
    visible: Shell.ready && GlobalStates.powerMenuOpen
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: powerMenuWidth
    implicitHeight: powerMenuHeight

    anchors {
        top: true
        right: false
        left: false
        bottom: false
    }

    margins {
        top: 20
        bottom: 20
        left: Appearance.margin.large
        right: Appearance.margin.large
    }

    StyledRect {
        id: container

        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.verylarge
        implicitWidth: powerMenu.powerMenuWidth
        anchors.fill: parent

        Item {
            id: content

            anchors.margins: 12
            anchors.topMargin: 16
            anchors.leftMargin: 18

            anchors.fill: parent

            Grid {
                columns: 3
                rows: 3
                rowSpacing: 10
                columnSpacing: 10
                anchors.fill: parent

                PowerMenuButton {
                    buttonIcon: "power_settings_new"
                    onClicked: Quickshell.execDetached(["poweroff"])
                }

                PowerMenuButton {
                    buttonIcon: "logout"
                    onClicked: Quickshell.execcDetached(["hyprctl", "dispatch", "exit"])
                }

                PowerMenuButton {
                    buttonIcon: "sleep"
                    onClicked: Quickshell.execDetached(["systemctl", "suspend"])
                }

                PowerMenuButton {
                    buttonIcon: "lock"
                    onClicked: Quickshell.execDetached(["hyprlock"])
                }

                PowerMenuButton {
                    buttonIcon: "restart_alt"
                    onClicked: Quickshell.execDetached(["reboot"])
                }

                PowerMenuButton {
                    buttonIcon: "light_off"
                    onClicked: Quickshell.execDetached(["systemctl", "hibernate"])
                }

            }

            component Anim: NumberAnimation {
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.standard
            }

        }

    }

    IpcHandler {
        function toggle() {
            togglepowerMenu();
        }

        target: "powerMenu"
    }

    Connections {
        function onFocusedMonitorChanged() {
            powerMenu.monitor = Hyprland.focusedMonitor;
        }

        target: Hyprland
    }

    component PowerMenuButton: StyledButton {
        property string buttonIcon

        icon: buttonIcon
        icon_size: 50
        width: powerMenu.implicitWidth / 3.4
        height: powerMenu.implicitHeight / 2.3
        radius: beingHovered ? Appearance.rounding.verylarge + 40 : Appearance.rounding.verylarge
    }

}
