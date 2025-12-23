import qs.settings
import qs.widgets
import qs.functions
import qs.services
import qs.modules.bar
import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts

BarModule {
    id: mediaContainer
    Layout.alignment: Qt.AlignVCenter


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
        radius: Shell.flags.bar.moduleRadius

        implicitWidth: textItem.implicitWidth + Appearance.margin.large
        implicitHeight: textItem.implicitHeight + Appearance.margin.small

        StyledText {
            id: textItem
            animate: true
            text: Stringify.shortText(activeToplevel?.title || `Workspace ${Hyprland.focusedWorkspaceId}`, 18)
            anchors.centerIn: parent
        }

    }
}