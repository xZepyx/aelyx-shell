import qs.config
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
        radius: Appearance.rounding.small

        implicitWidth: Appearance.margin.large
        implicitHeight: Config.options.bar.implicitHeight

        // --- Scroll to change brightness ---
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            scrollGestureEnabled: true

            onWheel: (wheelEvent) => {
                SessionState.osdNeeded = true;
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
