import qs.config
import qs.widgets
import qs.modules.bar.widgets
import qs.modules.bar.extras
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

            StyledRect {
                color: Appearance.m3colors.m3background
                anchors.fill: parent

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: Config.options.bar.autohide

                    onEntered: bar.implicitHeight = Config.options.bar.implicitHeight
                    onExited: bar.implicitHeight = 0
                }

                Binding {
                    target: bar
                    property: "implicitHeight"
                    when: !Config.options.bar.autohide
                    value: Config.options.bar.implicitHeight
                }

                Row {
                    id: centerRow
                    anchors.centerIn: parent
                    spacing: 4

                    LauncherToggle {}
                    Workspaces {}
                    UserHostname {}
                    Network {}
                    PowerMenuToggle {}
                }

                RowLayout {
                    id: rightRow
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    spacing: 8

                    SystemTray {}
                    Media {}
                    BluetoothWifi {}
                }

                RowLayout {
                    id: leftRow
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    spacing: 8

                    ActiveTopLevel {}
                    Clock {}
                }

                Volume {}
                Brightness {}
                MediaPlayer {}
                WindowOverview {}
            }
        }
    }
}
