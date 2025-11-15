import qs.core.appearance
import qs.core.config
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Scope {
    id: root

    Connections {
        target: Brightness

        function onBrightnessChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null

    property bool shouldShowOsd: false

    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            visible: SessionState.osdNeeded
            exclusiveZone: 0
            anchors.top: Config.options.bar.position === 1
            margins.top: Config.options.bar.position === 1 ? 10 : 0
            anchors.bottom: Config.options.bar.position === 2
            margins.bottom: Config.options.bar.position === 2 ? 10 : 0

            implicitWidth: 400
            implicitHeight: 70
            color: "transparent"
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: 20
                color: Appearance.m3colors.m3onSecondary

                RowLayout {
                    spacing: 10
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 15
                    }

                    MaterialSymbol {
                        property real brightnessLevel: Math.floor(Brightness.getMonitorForScreen(Hyprland.focusedMonitor)?.multipliedBrightness*100)
                        icon: {
                            if (brightnessLevel > 66) return "brightness_high"
                            else if (brightnessLevel > 33) return "brightness_medium"
                            else return "brightness_low"
                        }
                        iconSize: 30
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        implicitHeight: 40
                        spacing: 5

                        StyledText {            
                            animate: false
                            text: "Brightness - " + Math.round(monitor.brightness * 100) + '%'
                            font.pixelSize: 16
                        }

                        StyledSlider {
                            implicitHeight: 20
                            from: 0
                            to: 100
                            value: Math.round(monitor.brightness * 100)
                        }
                    }
                }
            }
        }
    }
}
