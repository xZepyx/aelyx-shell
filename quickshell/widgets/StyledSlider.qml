import qs.settings
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Slider {
    id: root

    property real trackHeightDiff: 15
    property real handleGap: 6
    property real trackDotSize: 4
    property real trackNearHandleRadius: 2
    property bool useAnim: true
    property int iconSize: Appearance.font.size.large 
    property string icon: ""

    Layout.fillWidth: true

    implicitWidth: 200
    implicitHeight: 40
    from: 0
    to: 100
    value: 0
    stepSize: 0
    snapMode: stepSize > 0 ? Slider.SnapAlways : Slider.NoSnap


    MouseArea {
        anchors.fill: parent
        onPressed: (mouse) => mouse.accepted = false
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
    }

    MaterialSymbol {
        id: icon 
        icon: root.icon
        iconSize: root.iconSize 
        anchors.right: parent.right 
        anchors.verticalCenter: parent.verticalCenter 
        anchors.rightMargin: 15
    }

    // ========= TRACK =========

    background: Item {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height

        // Filled Left Segment
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            width: root.handleGap + (root.visualPosition * (root.width - root.handleGap * 2))
                   - ((root.pressed ? 1.5 : 3) / 2 + root.handleGap)

            height: root.height - root.trackHeightDiff
            color: Appearance.colors.colPrimary
            radius: 10
            topRightRadius: root.trackNearHandleRadius
            bottomRightRadius: root.trackNearHandleRadius

            Behavior on width {
                NumberAnimation {
                    duration: !root.useAnim ? 0 : Appearance.animation.durations.small
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animation.curves.expressiveEffects
                }
            }
        }

        // Remaining Right Segment
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            width: root.handleGap + ((1 - root.visualPosition) * (root.width - root.handleGap * 2))
                   - ((root.pressed ? 1.5 : 3) / 2 + root.handleGap)

            height: root.height - root.trackHeightDiff
            color: Appearance.colors.colSecondaryContainer
            radius: 10
            topLeftRadius: root.trackNearHandleRadius
            bottomLeftRadius: root.trackNearHandleRadius

            Behavior on width {
                NumberAnimation {
                    duration: !root.useAnim ? 0 : Appearance.animation.durations.small
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animation.curves.expressiveEffects
                }
            }
        }
    }

    // ========= HANDLE =========

    handle: Rectangle {
        width: 5
        height: root.height
        radius: width / 2

        x: root.handleGap + (root.visualPosition * (root.width - root.handleGap * 2)) - width / 2
        anchors.verticalCenter: parent.verticalCenter

        color: Appearance.colors.colPrimary

        Behavior on x {
            NumberAnimation {
                duration: !root.useAnim ? 0 : Appearance.animation.elementMoveFast.duration
                easing.type: Appearance.animation.elementMoveFast.type
                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
            }
        }
    }
}
