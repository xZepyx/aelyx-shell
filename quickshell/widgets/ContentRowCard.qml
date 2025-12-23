import qs.settings
import QtQuick
import QtQuick.Layouts

Item {
    id: baseCard
    
    Layout.fillWidth: true
    
    implicitHeight: wpBG.implicitHeight

    default property alias content: contentArea.data
    property alias color: wpBG.color

    property int cardMargin: 20
    property int cardSpacing: 10
    property int radius: 20
    property int verticalPadding: 40

    Rectangle {
        id: wpBG
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: contentArea.implicitHeight + baseCard.verticalPadding
        Behavior on implicitHeight {
            NumberAnimation {
                duration: Appearance.animation.durations.small
                easing.type: Easing.InOutExpo
            }
        }
        color: Appearance.colors.m3surfaceContainerLow
        Behavior on color {
            ColorAnimation {
                duration: Appearance.animation.durations.small
                easing.type: Easing.InOutExpo
            }
        }
        radius: baseCard.radius
    }

    RowLayout {
        id: contentArea
        anchors.top: wpBG.top
        anchors.left: wpBG.left
        anchors.right: wpBG.right
        anchors.margins: baseCard.cardMargin
        spacing: baseCard.cardSpacing
    }
}