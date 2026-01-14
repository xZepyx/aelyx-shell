import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.modules.widgets

PanelWindow {
    id: root

    property int opacity: 0

    color: "transparent"
    visible: Config.initialized
    WlrLayershell.layer: WlrLayer.Top

    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }

    Item {
        id: container

        anchors.fill: parent

        StyledRect {
            anchors.fill: parent
            color: Appearance.m3colors.m3background
            layer.enabled: true
            opacity: root.opacity

            layer.effect: MultiEffect {
                maskSource: mask
                maskEnabled: true
                maskInverted: true
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1
            }

            Behavior on opacity {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: Appearance.animation.durations.large
                    easing.type: Easing.InOutExpo
                    easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
                }

            }

        }

        Item {
            id: mask

            anchors.fill: parent
            layer.enabled: true
            visible: false

            StyledRect {
                anchors.fill: parent
                anchors.topMargin: Config.runtime.bar.position === "bottom" ? -15 : 0
                anchors.bottomMargin: Config.runtime.bar.position === "top" ? -15 : 0
                anchors.leftMargin: Config.runtime.bar.position === "right" ? -15 : 0
                anchors.rightMargin: Config.runtime.bar.position === "left" ? -15 : 0
                radius: Appearance.rounding.normal
            }

        }

    }

    mask: Region {
        item: container
        intersection: Intersection.Xor
    }

}
