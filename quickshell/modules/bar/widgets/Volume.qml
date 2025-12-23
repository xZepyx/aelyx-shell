import qs.settings
import qs.modules.bar
import qs.services
import qs.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

BarModule {
    id: root

    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight
    anchors.right: parent.right
        

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

    Rectangle {
        id: bgRect
        color: "transparent"
        radius: Shell.flags.bar.moduleRadius

        implicitWidth: Appearance.margin.large
        implicitHeight: Shell.flags.bar.height

        property real volume: (Pipewire.defaultAudioSink?.audio.volume ?? 0)

        Component.onCompleted: {
            const node = Pipewire.defaultAudioSink?.audio
            if (node && node.bound)
                bgRect.volume = node.volume
        }

        // --- Scroll to change volume ---
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            scrollGestureEnabled: true 

            onWheel: (wheelEvent) => {
                const sink = Pipewire.defaultAudioSink?.audio
                if (!sink)
                    return

                const step = 0.01
                GlobalStates.osdNeeded = true;

                if (wheelEvent.angleDelta.y > 0) {
                    sink.volume = Math.min(sink.volume + step, 1)
                } else if (wheelEvent.angleDelta.y < 0) {
                    sink.volume = Math.max(sink.volume - step, 0)
                }
            }
        }
    }
}
