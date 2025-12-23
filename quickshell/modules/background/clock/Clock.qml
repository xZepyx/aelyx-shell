import qs.services
import qs.settings
import qs.widgets
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root 
    Variants {
        model: Quickshell.screens 
        PanelWindow {
            required property var modelData
            id: clock
            color: "transparent"
            visible: (Shell.flags.background.showClock && Shell.ready)
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Bottom
            screen: modelData

            implicitWidth: 250
            implicitHeight: 100

            property int borderLimit: 50

            // Load last saved position
            property int savedX: Shell.flags.background.clockX
            property int savedY: Shell.flags.background.clockY

            // margins now synced to both axes equally
            anchors {
                left: true
                top: true
            }
            margins {
                left: savedX
                top: savedY
                right: savedX
                bottom: savedY
            }

            Component.onCompleted: {
                // ensure saved positions are within screen limits
                const screenW = modelData.width
                const screenH = modelData.height
                const safeRight = screenW - implicitWidth - borderLimit
                const safeBottom = screenH - implicitHeight - borderLimit

                if (savedX < borderLimit || savedX > safeRight)
                    margins.left = borderLimit
                if (savedY < borderLimit || savedY > safeBottom)
                    margins.top = borderLimit
            }

            function savePosition() {
                Shell.setNestedValue("background.clockX", margins.left)
                Shell.setNestedValue("background.clockY", margins.top)
            }

            function moveRandomly() {
                const screenW = Screen.width
                const screenH = Screen.height

                const safeLeft = borderLimit
                const safeTop = borderLimit
                const safeRight = screenW - implicitWidth - borderLimit
                const safeBottom = screenH - implicitHeight - borderLimit

                const newX = Math.floor(Math.random() * (safeRight - safeLeft) + safeLeft)
                const newY = Math.floor(Math.random() * (safeBottom - safeTop) + safeTop)

                margins.left = newX
                margins.top = newY

                // Save after movement
                savePosition()
            }

            StyledText {
                id: textItem
                anchors.centerIn: parent
                animate: false
                text: Time.format(Shell.flags.background.clockTimeFormat)
                font.pixelSize: Appearance.font.size.wildass * 2
                font.family: Appearance.font.family.main
                font.bold: true
                color: Appearance.m3colors.m3primary
            }

            IpcHandler {
                target: "clock"
                function changePosition() {
                    moveRandomly()
                }
            }
        }

    }
}