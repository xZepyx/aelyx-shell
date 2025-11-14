import qs.core.appearance
import qs.core.config
import qs.common.widgets
import qs.modules.bar.content
import qs.modules.bar.contentWidgets
import QtQuick
import Quickshell
import QtQuick.Layouts


Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            visible: (Config.options.bar.enabled && Config.ready)

            required property var modelData

            color: "transparent"
            screen: modelData
            implicitHeight: Config.options.bar.implicitHeight

            anchors {
                top: Config.options.bar.position === 1
                bottom: Config.options.bar.position === 2
                left: true
                right: true
            }

            margins {
                readonly property bool floating: Config.options.bar.style === 1
                readonly property bool topBar: Config.options.bar.position === 1
                readonly property bool bottomBar: Config.options.bar.position === 2

                top: floating && topBar ? Appearance.margin.small : 0
                bottom: floating && bottomBar ? Appearance.margin.small : 0
                left: floating ? Appearance.margin.small : 0
                right: floating ? Appearance.margin.small : 0
            }

            StyledRect {
                color: Appearance.m3colors.m3background
                anchors.fill: parent
                radius: Config.options.bar.style === 1 ? Config.options.bar.radius : 0

                Row {
                    id: centerRow
                    anchors {
                        centerIn: parent
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 4

                    LauncherToggle{}   
                    Workspaces{}    
                    UserHostname{}
                    Network{}
                    PowerMenuToggle{}
        
                }

                RowLayout {
                    id: rightRow 
                    anchors.right: parent.right 
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Media{}
                    BluetoothWifi{}

                }

                RowLayout {
                    id: leftRow 
                    anchors.left: parent.left 
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter

                    //Glyph{}
                    ActiveTopLevel{}
                    Clock{}
                    
                    
                }

                Volume{}
                Brightness{}
                MediaPlayer{}
                WindowOverview{}

            }
        }
    }
}