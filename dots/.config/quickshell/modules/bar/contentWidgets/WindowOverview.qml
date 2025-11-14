import qs.core.appearance
import qs.core.config
import qs.common.widgets
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: windowOverview
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.ready 

    color: "transparent"
    focusable: true
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1

    property Toplevel activeToplevel: Hyprland.isWorkspaceOccupied(Hyprland.focusedWorkspaceId)
        ? Hyprland.activeToplevel
        : null


    property real windowOverviewWidth: 385
    property real windowOverviewHeight: 240

    implicitWidth: windowOverviewWidth
    implicitHeight: windowOverviewHeight

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
        intersection: SessionState.windowOverviewOpen ? Intersection.Combine : Intersection.Xor
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "transparent"
        opacity: SessionState.windowOverviewOpen ? 1 : 0
        Behavior on opacity { Anim {} }

        MouseArea {
            anchors.fill: parent
            enabled: SessionState.windowOverviewOpen
            onClicked: SessionState.windowOverviewOpen = false
        }
    }

    Item {
        id: keyCatcher
        anchors.fill: parent
        focus: SessionState.windowOverviewOpen
        Keys.onEscapePressed: SessionState.windowOverviewOpen = false
    }

    MergedEdgeRect {
        id: container
        visible: implicitHeight > 0
        color: Appearance.m3colors.m3background
        cornerRadius: Appearance.rounding.verylarge
        implicitWidth: windowOverview.windowOverviewWidth
        implicitHeight: SessionState.windowOverviewOpen ? windowOverview.windowOverviewHeight : 0

        Behavior on implicitHeight { Anim {} }

        anchors {
            left: parent.left
            rightMargin: Config.options.global.borderEnabled ? Appearance.margin.tiny + 2 : 0
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        states: [
            State {
                name: "toAtBottom"
                when: Config.options.bar.position === 2
                AnchorChanges {
                    target: container
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "toAtTop"
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
            anchors.leftMargin: 20
            anchors.topMargin: 10
            opacity: SessionState.windowOverviewOpen ? 1 : 0
            Behavior on opacity { Anim {} }

            Rectangle {
                id: windowCard
                width: 300        
                height: 170       
                radius: 10
                color: Appearance.m3colors.m3paddingContainer
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: windowCard.width
                        height: windowCard.height
                        radius: windowCard.radius
                    }
                }
    
                StyledText {
                    id: windowTitle
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    z: 1                       
                    text: shortText(activeToplevel?.title || `Workspace ${Hyprland.focusedWorkspaceId}`)
                }

                ScreencopyView {
                    id: livePreview
                    anchors.fill: parent
                    live: true
                    captureSource: ToplevelManager?.activeToplevel 
                    visible: windowOverview.activeToplevel !== null
                }

                Image {
                    id: wallpaperPreview
                    anchors.fill: parent
                    source: Config.options.background.wallpaperPath
                    fillMode: Image.PreserveAspectCrop
                    visible: windowOverview.activeToplevel === null
                }
            }
        }
    }

    // --- Toggle logic ---
    function togglewindowOverview() {
        const newState = !SessionState.windowOverviewOpen
        SessionState.windowOverviewOpen = newState
        if (newState)
            windowOverview.forceActiveFocus()
        else
            windowOverview.focus = false
    }

    IpcHandler {
        target: "windowOverview"
        function toggle() {
            togglewindowOverview()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            windowOverview.monitor = Hyprland.focusedMonitor
        }
    }
}
