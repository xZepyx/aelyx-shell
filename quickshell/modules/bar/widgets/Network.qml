import qs.settings
import qs.modules.bar
import qs.services
import qs.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell

BarModule {
    id: root
    height: 33
    Layout.alignment: Qt.AlignVCenter

    // Wrap everything in a background rectangle that sizes to content
    Rectangle {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius
        anchors.fill: parent

        implicitWidth: contentRow.implicitWidth + Appearance.margin.large 
        implicitHeight: contentRow.implicitHeight + Appearance.margin.large

        MouseArea {
            anchors.fill: parent
            onClicked: Quickshell.execDetached(["kitty", "nmtui"])
        }

        Row {
            id: contentRow
            anchors.centerIn: parent
            
            anchors.verticalCenter: parent.verticalCenter
            
            spacing: 6

            MaterialSymbol {
                id: wifiIcon
                icon: {
                    const s = Network.signalStrength;
                    if (s > 80)
                        return "network_wifi_3_bar";
                    if (s > 60)
                        return "network_wifi_2_bar";
                    if (s > 40)
                        return "network_wifi_1_bar";
                    return "network_wifi_1_bar";
                }
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                id: textSsid
                animate: false
                text: Network.connectedSsid + " (" + Network.signalStrength + "%)"
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1
            }
        }
    }

    implicitWidth: bgRect.implicitWidth 
    implicitHeight: bgRect.implicitHeight - 10
}
