import qs.widgets
import qs.settings
import qs.modules.bar.widgets
import Quickshell 
import Quickshell.Wayland
import QtQuick

Scope {
    id: root 

    GothCorners {
        visible: Shell.flags.bar.gothCorners && !Shell.flags.bar.floating && !Shell.flags.bar.floatingModules
    } 
                    
    Variants {
        model: Quickshell.screens 
        
        StaticWindow {
            required property var modelData
            screen: modelData
            id: barWindow 
            namespace: "aelyx:bar"
            visible: Shell.flags.bar.enabled
            implicitHeight: Shell.flags.bar.height
            implicitWidth: Shell.flags.bar.width

            anchors {
                top: Shell.flags.bar.atTop
                bottom: !Shell.flags.bar.atTop
                left: true 
                right: true
            }

            margins {
                top: Shell.flags.bar.floating ? 10 : 0
                bottom: Shell.flags.bar.floating ? 10 : 0
                left: Shell.flags.bar.floating ? 10 : 0
                right: Shell.flags.bar.floating ? 10 : 0
            }

            StyledRect {
                anchors.fill: parent
                radius: Shell.flags.bar.floating ? Shell.flags.bar.radius : 0
                color: Appearance.m3colors.m3background
                opacity: Shell.flags.bar.floatingModules ? 0 : 1.0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            BarContent {
                anchors.fill: parent
            }

        }
    }
}