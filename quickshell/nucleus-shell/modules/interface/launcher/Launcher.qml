import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import qs.config
import qs.modules.functions
import qs.modules.widgets
import qs.services

PanelWindow {
    id: launcher

    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1
    property real launcherWidth: screenW * 0.28 / scale
    property real launcherHeight: screenH * 0.7 / scale

    function togglelauncher() {
        Globals.visiblility.launcher = !Globals.visiblility.launcher;
        if (!Globals.visiblility.launcher) {
            searchField.text = "";
            launcherContent.resetSearch();
        }
    }

    WlrLayershell.layer: WlrLayer.Top
    visible: Config.initialized && Globals.visiblility.launcher
    WlrLayershell.keyboardFocus: Globals.visiblility.launcher
    WlrLayershell.namespace: "nucleus:launcher"
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: launcherWidth
    implicitHeight: launcherHeight
    onVisibleChanged: {
        if (!Globals.visiblility.launcher) {
            searchField.text = "";
            launcherContent.resetSearch();
        } else {
            Qt.callLater(() => {
                return searchField.forceActiveFocus();
            });
        }
    }

    anchors {
        top: true
        left: false
        right: false
        bottom: false
    }

    margins {
        top: 10
        bottom: 10
        left: 10
        right: 10
    }

    FocusScope {
        id: launcherFocus

        anchors.fill: parent
        focus: true
        Keys.onPressed: (event) => {
            switch (event.key) {
            case Qt.Key_Down:
                launcherContent.moveSelection(+1);
                event.accepted = true;
                break;
            case Qt.Key_Up:
                launcherContent.moveSelection(-1);
                event.accepted = true;
                break;
            case Qt.Key_Return:
            case Qt.Key_Enter:
                launcherContent.launchCurrent();
                event.accepted = true;
                break;
            case Qt.Key_Escape:
                launcherContent.closeLauncher();
                event.accepted = true;
                break;
            }
        }

        StyledRect {
            color: Appearance.m3colors.m3background
            topLeftRadius: Appearance.rounding.verylarge
            topRightRadius: Appearance.rounding.verylarge
            bottomLeftRadius: searchField.text !== "" ? 0 : Appearance.rounding.verylarge
            bottomRightRadius: searchField.text !== "" ? 0 : Appearance.rounding.verylarge
            implicitWidth: launcher.launcherWidth
            implicitHeight: 65
            anchors.top: parent.top

            StyledTextField {
                id: searchField

                height: 50
                filled: false
                radius: Appearance.rounding.verylarge
                anchors.fill: parent
                icon: ""
                highlight: false
                placeholder: "Search applications..."
                font.pixelSize: 15
                outline: false
                onTextChanged: {
                    if (launcherContent.searchQuery === text)
                        return;

                    launcherContent.searchQuery = text;
                    launcherContent.updateFilter();
                }

            }

            Behavior on bottomLeftRadius {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.BezierSpline
                }

            }

            Behavior on bottomRightRadius {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.BezierSpline
                }

            }

        }

        StyledRect {
            // padding compensation

            id: container

            readonly property real maxResultsHeight: launcher.launcherHeight - 130
            readonly property real contentHeightClamped: Math.min(launcherContent.listView.contentHeight + 50, maxResultsHeight)

            color: Appearance.m3colors.m3background
            topLeftRadius: searchField.text !== "" ? 0 : Appearance.rounding.verylarge
            topRightRadius: searchField.text !== "" ? 0 : Appearance.rounding.verylarge
            bottomLeftRadius: Appearance.rounding.verylarge 
            bottomRightRadius: Appearance.rounding.verylarge
            opacity: searchField.text !== "" ? 1 : 0
            anchors.top: parent.top
            anchors.topMargin: 65
            implicitWidth: launcher.launcherWidth
            implicitHeight: searchField.text !== "" ? contentHeightClamped : 0

            Rectangle {
                anchors.top: parent.top
                height: 1
                width: parent.width
                color: Appearance.colors.colOutline
            }

            LauncherContent {
                id: launcherContent

                searchQuery: searchField.text
                anchors.fill: parent
            }

            Behavior on topLeftRadius {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.BezierSpline
                }

            }

            Behavior on topRightRadius {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.BezierSpline
                }

            }

            Behavior on implicitHeight {
                enabled: Config.runtime.appearance.animations.enabled
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }

        }

    }

    IpcHandler {
        function toggle() {
            togglelauncher();
        }

        target: "launcher"
    }

    Connections {
        function onFocusedMonitorChanged() {
            launcher.monitor = Hyprland.focusedMonitor;
        }

        target: Hyprland
    }

}
