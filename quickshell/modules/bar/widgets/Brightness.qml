import qs.settings
import qs.modules.bar
import qs.services
import qs.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell

BarModule {
    id: root

    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight
    anchors.left: parent.left

    Rectangle {
        id: bgRect
        color: "transparent"
        radius: Shell.flags.bar.moduleRadius

        implicitWidth: Appearance.margin.large
        implicitHeight: Shell.flags.bar.height

        // --- Scroll to change brightness ---
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            scrollGestureEnabled: true

            onWheel: (wheelEvent) => {
                GlobalStates.osdNeeded = true;
                const step = 0.05
                if (wheelEvent.angleDelta.y > 0) {
                    Brightness.increaseBrightness()
                } else if (wheelEvent.angleDelta.y < 0) {
                    Brightness.decreaseBrightness()
                }
            }
        }
    }
}
