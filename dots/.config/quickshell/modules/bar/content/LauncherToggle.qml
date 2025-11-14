import QtQuick 
import Quickshell
import QtQuick.Layouts
import qs.services
import qs.core.config
import qs.core.appearance
import qs.common.widgets 


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
        font.pixelSize: 22
        text: Config.options.bar.launcherToggleSymbol
    }

    MouseArea {
        anchors.fill: parent
        onClicked: SessionState.launcherOpen = true
    }

}
