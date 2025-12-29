import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.settings
import qs.widgets

StyledText {
    id: glyph

    Layout.alignment: Qt.AlignLeft
    Layout.leftMargin: 10
    font.pixelSize: 26
    text: SystemDetails.osIcon
    color: GlobalStates.sidebarLeftOpen || ma.containsMouse ? Appearance.m3colors.m3primary : Appearance.syntaxHighlightingTheme

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            GlobalStates.sidebarLeftOpen = !GlobalStates.sidebarLeftOpen;
        }
    }

}
