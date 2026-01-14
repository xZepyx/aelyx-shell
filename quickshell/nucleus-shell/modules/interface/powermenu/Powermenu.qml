import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import qs.modules.functions
import qs.modules.interface.lockscreen
import qs.services
import qs.config
import qs.modules.widgets

PanelWindow {
    id: powermenu
    WlrLayershell.namespace: "nucleus:powermenu"
    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1
    property real powermenuWidth: screenW * 0.25/ scale
    property real powermenuHeight: screenH * 0.30 / scale

    // --- Toggle logic ---
    function togglepowermenu() {
        Globals.visiblility.powermenu = !Globals.visiblility.powermenu; // Simple toggle logic kept in a function as it might have more things to it later on.
    }

    WlrLayershell.layer: WlrLayer.Top
    visible: Config.initialized && Globals.visiblility.powermenu
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: powermenuWidth
    implicitHeight: powermenuHeight

    anchors {
        top: true
        right: false
        left: false
        bottom: false
    }

    margins {
        top: screenH / 3 // I used these weird values to fix it not appearing on focused monitors. It's a wayland issue.
        bottom: 20
        left: Appearance.margin.large
        right: Appearance.margin.large
    }

    StyledRect {
        id: container

        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.verylarge
        implicitWidth: powermenu.powermenuWidth
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
                    onClicked: {
                        Quickshell.execDetached(["poweroff"])
                        Globals.visiblility.powermenu = false
                    }
                }

                PowerMenuButton {
                    buttonIcon: "logout"
                    onClicked: {
                        Quickshell.execDetached(["hyprctl", "dispatch", "exit"])
                        Globals.visiblility.powermenu = false
                    }
                }

                PowerMenuButton {
                    buttonIcon: "sleep"
                    onClicked: {
                        Quickshell.execDetached(["systemctl", "suspend"])
                        Globals.visiblility.powermenu = false
                    }
                }

                PowerMenuButton {
                    buttonIcon: "lock"
                    onClicked: {
                        Quickshell.execDetached(["qs", "-c", "nucleus-shell", "ipc", "call", "lockscreen", "lock"])
                        Globals.visiblility.powermenu = false
                    }
                }

                PowerMenuButton {
                    buttonIcon: "restart_alt"
                    onClicked: {
                        Quickshell.execDetached(["reboot"])
                        Globals.visiblility.powermenu = false
                    }
                }

                PowerMenuButton {
                    buttonIcon: "light_off"
                    onClicked: {
                        Quickshell.execDetached(["systemctl", "hibernate"])
                        Globals.visiblility.powermenu = false
                    }
                }

            }

            component Anim: NumberAnimation {
                running: Config.runtime.appearance.animations.enabled
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.standard
            }

        }

    }

    IpcHandler {
        function toggle() {
            togglepowermenu();
        }

        target: "powermenu"
    }

    Connections {
        function onFocusedMonitorChanged() {
            powermenu.monitor = Hyprland.focusedMonitor;
        }
        // Idk if this really works but I belive it does. (I've tested it on 2 monitors it works. But also works without it because Wlrlayershell does that. But I'll keep this.)
        target: Hyprland
    }

    component PowerMenuButton: StyledButton {
        property string buttonIcon

        icon: buttonIcon
        iconSize: 50
        width: powermenu.implicitWidth / 3.4
        height: powermenu.implicitHeight / 2.3
        radius: beingHovered ? Appearance.rounding.verylarge * 2 : Appearance.rounding.verylarge
    }

}
