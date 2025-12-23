import qs.settings
import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 60
    height: 34

    property bool checked: false
    signal toggled(bool checked)

    // Colors from Appearance
    property color trackOn: Appearance.colors.colPrimary
    property color trackOff: Appearance.colors.colLayer2
    property color thumbColorOn: Appearance.colors.colOnPrimary
    property color thumbColorOff: Appearance.colors.colOnLayer2
    property color iconColor: Appearance.colors.colPrimary

    // Dimensions
    property int trackRadius: height / 2
    property int thumbSize: height - (checked ? 12 : 18)
    Behavior on thumbSize { 
        NumberAnimation { 
            duration: Appearance.animation.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animation.curves.expressiveEffects
        } 
    }

    Rectangle {
        id: track
        anchors.fill: parent
        radius: trackRadius
        color: root.checked ? trackOn : trackOff
        border.width: root.checked ? 0 : 2
        border.color: Appearance.colors.colOutline
        Behavior on color { 
            ColorAnimation { 
                duration: Appearance.animation.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            } 
        }
    }

    Rectangle {
        id: thumb
        width: thumbSize
        height: thumbSize
        radius: thumbSize / 2
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? parent.width - width - 6 : 9
        color: root.checked ? thumbColorOn : thumbColorOff

        Behavior on x { 
            NumberAnimation { 
                duration: Appearance.animation.durations.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            } 
        }
        Behavior on color { 
            ColorAnimation { 
                duration: Appearance.animation.durations.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            } 
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.checked = !root.checked
            root.toggled(root.checked)
        }
    }
}
