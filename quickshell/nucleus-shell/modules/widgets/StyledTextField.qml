import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.config
import qs.modules.functions

TextField {
    id: control

    property string icon: ""
    property color iconColor: Appearance.m3colors.m3onSurfaceVariant
    property string placeholder: ""
    property real iconSize: 24
    property alias radius: bg.radius
    property bool outline: true
    property alias topLeftRadius: bg.topLeftRadius
    property alias topRightRadius: bg.topRightRadius
    property alias bottomLeftRadius: bg.bottomLeftRadius
    property alias bottomRightRadius: bg.bottomRightRadius
    property color backgroundColor: filled ? Appearance.m3colors.m3surfaceContainerHigh : "transparent"
    property int fieldPadding: 20
    property int iconSpacing: 14
    property int iconMargin: 20
    property bool filled: true
    property bool highlight: true

    width: parent ? parent.width - 40 : 300
    placeholderText: placeholder
    leftPadding: icon !== "" ? iconSize + iconSpacing + iconMargin : fieldPadding
    padding: fieldPadding
    verticalAlignment: TextInput.AlignVCenter
    color: Appearance.m3colors.m3onSurface
    placeholderTextColor: Appearance.m3colors.m3onSurfaceVariant
    font.family: "Outfit"
    font.pixelSize: 14
    cursorVisible: control.focus

    MaterialSymbol {
        icon: control.icon
        anchors.left: parent.left
        anchors.leftMargin: icon !== "" ? iconMargin : 0
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: control.iconSize
        color: control.iconColor
        visible: control.icon !== ""

        Behavior on color {
            ColorAnimation {
                duration: Appearance.animation.durations.small
                easing.type: Appearance.animation.easing
            }

        }

    }

    cursorDelegate: Rectangle {
        width: 2
        color: Appearance.m3colors.m3primary
        visible: control.focus

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: control.focus && Config.runtime.appearance.animations.enabled

            NumberAnimation {
                from: 1
                to: 0
                duration: Appearance.animation.durations.large * 2
            }

            NumberAnimation {
                from: 0
                to: 1
                duration: Appearance.animation.durations.large * 2
            }

        }

    }

    background: Item {
        Rectangle {
            id: bg

            anchors.fill: parent
            radius: 4
            color: control.backgroundColor

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: {
                    if (control.activeFocus && control.highlight)
                        return ColorUtils.transparentize(Appearance.m3colors.m3primary, 0.8);

                    if (control.hovered && control.highlight)
                        return ColorUtils.transparentize(Appearance.m3colors.m3onSurface, 0.9);

                    return "transparent";
                }

                Behavior on color {
                    enabled: Config.runtime.appearance.animations.enabled

                    ColorAnimation {
                        duration: Appearance.animation.durations.small
                        easing.type: Appearance.animation.easing
                    }

                }

            }

        }

        Rectangle {
            id: indicator

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: control.activeFocus ? 2 : 1
            color: {
                if (control.activeFocus)
                    return Appearance.m3colors.m3primary;

                if (control.hovered)
                    return Appearance.m3colors.m3onSurface;

                return Appearance.m3colors.m3onSurface;
            }
            visible: filled

            Behavior on height {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: Appearance.animation.durations.small
                    easing.type: Appearance.animation.easing
                }

            }

            Behavior on color {
                enabled: Config.runtime.appearance.animations.enabled
                ColorAnimation {
                    duration: Appearance.animation.durations.small
                    easing.type: Appearance.animation.easing
                }

            }

        }

        Rectangle {
            id: outline

            anchors.fill: parent
            radius: bg.radius
            color: "transparent"
            border.width: control.activeFocus ? 2 : 1
            border.color: {
                if (control.activeFocus)
                    return Appearance.m3colors.m3primary;

                if (control.hovered)
                    return Appearance.m3colors.m3onSurface;

                return Appearance.m3colors.m3outline;
            }
            visible: !filled && control.outline

            Behavior on border.width {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: Appearance.animation.durations.small
                    easing.type: Appearance.animation.easing
                }

            }

            Behavior on border.color {
                enabled: Config.runtime.appearance.animations.enabled
                ColorAnimation {
                    duration: Appearance.animation.durations.small
                    easing.type: Appearance.animation.easing
                }

            }

        }

    }

}
