import qs.settings
import qs.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Controls


StyledSlider {
    id: volSlider
    Layout.fillWidth: true
    from: 0
    to: 1
    stepSize: 0.01
    value: sink ? sink.volume : 0

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    property real level: volSlider.value * 100

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink?.audio


    onMoved: { 
        if (sink) sink.volume = value
        GlobalStates.osdNeeded = false;
    }
}
