import qs.settings
import QtQuick
import QtQuick.Layouts

Item {
    id: contentCard
    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: wpBG.implicitHeight

    default property alias content: contentArea.data
    property alias color: wpBG.color
    property alias radius: wpBG.radius
    property int cardMargin: Appearance.margin.normal
    property int cardSpacing: Appearance.margin.small
    property int verticalPadding: Appearance.margin.verylarge
    property bool useAnims: false

    Rectangle {
        id: wpBG
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: contentArea.implicitHeight + contentCard.verticalPadding

        // Animate implicitHeight using Appearance animation
        Behavior on implicitHeight {
            NumberAnimation {
                duration: !contentCard.useAnims ? 0 : Appearance.animation.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            }
        }

        color: Appearance.colors.colLayer1
        Behavior on color {
            ColorAnimation {
                duration: !contentCard.useAnims ? 0 : Appearance.animation.durations.fast
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animation.curves.expressiveEffects
            }
        }

        radius: Appearance.rounding.normal
    }

    ColumnLayout {
        id: contentArea
        anchors.top: wpBG.top
        anchors.left: wpBG.left
        anchors.right: wpBG.right
        anchors.margins: contentCard.cardMargin
        spacing: contentCard.cardSpacing
    }
}