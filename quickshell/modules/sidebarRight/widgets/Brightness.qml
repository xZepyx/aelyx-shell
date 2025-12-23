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
    id: brightnessSlider
    Layout.fillWidth: true
    from: 0
    to: 1
    stepSize: 0.01
    property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null
    value: monitor ? monitor.brightness : 0.5

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    property real level: brightnessSlider.value * 100

    onMoved: if (monitor) {
        GlobalStates.osdNeeded = false;
        monitor.setBrightness(value);
    }
}
