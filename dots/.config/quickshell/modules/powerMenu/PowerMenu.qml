import qs.config
import qs.widgets
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: powerMenu
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.ready

    color: "transparent"
    focusable: true
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1 // Not used in a lot of configs but I still keep these in some files.


    property real powerMenuWidth: 660
    property real powerMenuHeight: 130

    implicitWidth: powerMenuWidth
    implicitHeight: powerMenuHeight

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
        intersection: SessionState.powerMenuOpen ? Intersection.Combine : Intersection.Xor
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "transparent"
        opacity: SessionState.powerMenuOpen ? 1 : 0
        Behavior on opacity { Anim {} }

        MouseArea {
            anchors.fill: parent
            enabled: SessionState.powerMenuOpen
            onClicked: SessionState.powerMenuOpen = false
        }
    }

    Item {
        id: keyCatcher
        anchors.fill: parent
        focus: SessionState.powerMenuOpen
        Keys.onEscapePressed: SessionState.powerMenuOpen = false
    }

    component PowerButton: Item {
        property string icon: ""
        property string label: ""
        property string command: ""
        property bool hovered: false

        width: 115
        height: 110

        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.margins: 12

        Rectangle {        
            anchors.fill: parent        
            radius: Appearance.rounding.large
            opacity: hovered ? 1 : 0
            Behavior on opacity { Anim {} }
            color: hovered ? Qt.darker(Appearance.m3colors.m3onSecondary, 1.3)
                        : Appearance.m3colors.m3paddingContainer
        }

        Text {
            anchors.centerIn: parent
            font.family: "Material Symbols Rounded"
            font.pointSize: 30
            text: icon
            color: Appearance.m3colors.m3onSurface
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
            onClicked: {
                if (command !== "")
                    Quickshell.execDetached([command])
                SessionState.powerMenuOpen = false
            }
        }

        ToolTip {
            text: label
            visible: parent.hovered
            delay: 800
            background: Rectangle {
                width: parent.width 
                height: parent.height 
                color: Appearance.m3colors.m3surfaceContainerHighest
                radius: Appearance.rounding.small
            }
        }
    }

    MergedEdgeRect {
        id: container
        visible: implicitHeight > 0
        color: Appearance.m3colors.m3background
        cornerRadius: Appearance.rounding.verylarge
        implicitWidth: powerMenu.powerMenuWidth
        implicitHeight: SessionState.powerMenuOpen ? powerMenu.powerMenuHeight : 0

        Behavior on implicitHeight { Anim {} }

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        states: [
            State {
                name: "pmAtBottom"
                when: Config.options.bar.position === 2
                AnchorChanges {
                    target: container
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "pmAtTop"
                when: Config.options.bar.position === 1
                AnchorChanges {
                    target: container
                    anchors.bottom: undefined
                    anchors.top: parent.top
                }
            }
        ]

        content: Row {
            opacity: SessionState.powerMenuOpen ? 1 : 0
            Behavior on opacity { Anim {} }
            id: buttonRow
            anchors.centerIn: parent
            spacing: 14
            anchors.verticalCenter: parent.verticalCenter  
            anchors.horizontalCenter: parent.horizontalCenter   
            anchors.verticalCenterOffset: Config.options.bar.position === 1 ? 5 : -5
            

            PowerButton {
                icon: "logout"
                label: "Logout"
                command: "swaymsg exit"
            }

            PowerButton {
                icon: "hotel"
                label: "Sleep"
                command: "systemctl suspend"
            }

            PowerButton {
                icon: "restart_alt"
                label: "Restart"
                command: "systemctl reboot"
            }

            PowerButton {
                icon: "power_settings_new"
                label: "Shutdown"
                command: "systemctl poweroff"
            }
        }

    }

    // --- Toggle logic ---
    function toggleMenu() {
        const newState = !SessionState.powerMenuOpen
        SessionState.powerMenuOpen = newState
        if (newState)
            powerMenu.forceActiveFocus()
        else
            powerMenu.focus = false
    }

    IpcHandler {
        target: "powerMenu"
        function toggle() {
            toggleMenu()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            powerMenu.monitor = Hyprland.focusedMonitor
        }
    }
}
