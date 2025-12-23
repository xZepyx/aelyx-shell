import qs.settings
import qs.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Control {
    id: root
    property alias text: label.text
    property string icon: ""
    property int icon_size: 20
    property alias radius: background.radius
    property alias topLeftRadius: background.topLeftRadius
    property alias topRightRadius: background.topRightRadius
    property alias bottomLeftRadius: background.bottomLeftRadius
    property alias bottomRightRadius: background.bottomRightRadius
    property bool checkable: false
    property bool checked: true
    property bool secondary: false
    property bool beingHovered: mouse_area.containsMouse
    
    signal clicked
    signal toggled(bool checked)

    // --- state colors ---
    property bool usePrimary: secondary ? false : checked

    property color base_bg: usePrimary
        ? Appearance.m3colors.m3primary
        : Appearance.m3colors.m3secondaryContainer   

    property color base_fg: usePrimary
        ? Appearance.m3colors.m3onPrimary
        : Appearance.m3colors.m3onSecondaryContainer

    // Disabled colors
    property color disabled_bg: ColorModifier.transparentize(base_bg, 0.4)
    property color disabled_fg: ColorModifier.transparentize(base_fg, 0.4)

    property color hover_bg: Qt.lighter(base_bg, 1.1)
    property color pressed_bg: Qt.darker(base_bg, 1.2)

    property color background_color: !root.enabled
        ? disabled_bg
        : mouse_area.pressed
            ? pressed_bg
            : mouse_area.containsMouse ? hover_bg : base_bg

    property color text_color: !root.enabled ? disabled_fg : base_fg

    implicitWidth: (label.text === "" && icon !== "")
        ? implicitHeight
        : row.implicitWidth + implicitHeight
    implicitHeight: 40

    contentItem: Item {
        anchors.fill: parent
        Row {
            id: row
            anchors.centerIn: parent
            spacing: root.icon !== "" && label.text !== "" ? Appearance.margin.tiny : 0

            MaterialSymbol {
                visible: root.icon !== ""
                icon: root.icon
                iconSize: root.icon_size
                color: root.text_color
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color {
                    ColorAnimation {
                        duration: Appearance.animation.durations.normal / 2
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.animation.curves.expressiveEffects
                    }
                }
            }

            StyledText {
                id: label
                font.pixelSize: Appearance.font.size.normal
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                Behavior on color {
                    ColorAnimation {
                        duration: Appearance.animation.durations.normal / 2
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.animation.curves.expressiveEffects
                    }
                }
            }
        }
    }

    background: Rectangle {
        id: background
        radius: Appearance.rounding.normal
        color: root.background_color
        Behavior on color {
            ColorAnimation {
                duration: Appearance.animation.durations.normal / 2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            }
        }
        Behavior on radius {
            NumberAnimation {
                duration: Appearance.animation.durations.normal / 2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            }
        }
        Behavior on topLeftRadius {
            NumberAnimation {
                duration: Appearance.animation.durations.large
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            }
        }
        Behavior on topRightRadius {
            NumberAnimation {
                duration: Appearance.animation.durations.large
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            }
        }
        Behavior on bottomLeftRadius {
            NumberAnimation {
                duration: Appearance.animation.durations.large
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            }
        }
        Behavior on bottomRightRadius {
            NumberAnimation {
                duration: Appearance.animation.durations.large
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            }
        }
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        hoverEnabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
        onClicked: {
            if (!root.enabled) return
            if (root.checkable) {
                root.checked = !root.checked
                root.toggled(root.checked)
            }
            root.clicked()
        }
    }
}
