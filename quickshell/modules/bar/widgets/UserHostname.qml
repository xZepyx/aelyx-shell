import qs.widgets
import qs.services
import qs.modules.bar
import qs.settings
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts

BarModule {
    id: container
    Layout.alignment: Qt.AlignVCenter

    property Toplevel activeToplevel: Hyprland.isWorkspaceOccupied(Hyprland.focusedWorkspaceId)
        ? Hyprland.activeToplevel
        : null

    // Let layout calculate size dynamically
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight
    property string userHostname: SystemDetails.username + "@" + SystemDetails.hostname 

    Rectangle {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius

        implicitWidth: textItem.implicitWidth + Appearance.margin.large
        implicitHeight: textItem.implicitHeight + Appearance.margin.small

        StyledText {
            id: textItem
            animate: true
            text: container.userHostname
            anchors.centerIn: parent
        }
    }
}
