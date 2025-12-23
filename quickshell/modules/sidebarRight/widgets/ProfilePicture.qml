import qs.settings
import qs.widgets 
import qs.modules.bar
import QtQuick 
import Quickshell
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

BarModule {
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter        
    Layout.preferredWidth: pfp.width             
    Layout.preferredHeight: pfp.height

    Rectangle {
        id: pfp
        width: 100
        height: 100
        color: "transparent"
        radius: Appearance.rounding.normal + 2

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: pfp.width
                height: pfp.height
                radius: pfp.radius
            }
        }

        Image {
            anchors.fill: parent
            source: Shell.flags.misc.pfp
            fillMode: Image.PreserveAspectCrop
            cache: true
            opacity: 0.9
        }
    }
}
