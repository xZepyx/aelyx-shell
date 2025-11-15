import qs.core.appearance
import qs.common.widgets
import qs.common.functions
import qs.services
import qs.modules.bar
import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts

BarModule {
    id: mediaContainer
    Layout.alignment: Qt.AlignVCenter
    Layout.leftMargin: Appearance.margin.large

    MouseArea {
        anchors.fill: parent 
        onClicked: SessionState.windowOverviewOpen = !SessionState.windowOverviewOpen
    }

    property Toplevel activeToplevel: Hyprland.isWorkspaceOccupied(Hyprland.focusedWorkspaceId)
        ? Hyprland.activeToplevel
        : null

    // Let layout calculate size dynamically
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    Rectangle {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: Appearance.rounding.normal

        implicitWidth: textItem.implicitWidth + Appearance.margin.large
        implicitHeight: textItem.implicitHeight + Appearance.margin.small

        StyledText {
            id: textItem
            animate: true
            text: Stringify.shortText(activeToplevel?.title || `Workspace ${Hyprland.focusedWorkspaceId}`)
            anchors.centerIn: parent
        }

    }
}