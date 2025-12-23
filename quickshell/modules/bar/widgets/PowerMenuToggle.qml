import qs.settings 
import qs.widgets 
import QtQuick 
import Quickshell
import QtQuick.Layouts

Rectangle {
    id: bgRect
    color: Appearance.m3colors.m3paddingContainer
    radius: Appearance.rounding.full

    implicitWidth: textItem.implicitWidth + 12
    implicitHeight: textItem.implicitHeight + 6

    MaterialSymbol {
        id: textItem
        anchors.centerIn: parent         
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0.4
        anchors.horizontalCenter: parent.horizontalCenter       
        iconSize: 22
        icon: "power_settings_new"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.powerMenuOpen = !GlobalStates.powerMenuOpen
    }

}
