import qs.config 
import qs.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore 
import Quickshell
import Quickshell.Widgets
import QtQuick.Effects

ContentMenu {
    title: "About"
    description: "About this configuration."
    ContentCard {

        ClippingRectangle {
            id: wpContainer
            Layout.alignment: Qt.AlignHCenter
            width: root.screen.width / 2
            height: width * root.screen.height / root.screen.width
            radius: 40
            color: Appearance.colors.m3surfaceContainer


            Image {
                id: icon
                source: StandardPaths.writableLocation(StandardPaths.ConfigLocation)
                    + "/quickshell/defaults/user/aelyx-logo.jpg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                Layout.alignment: Qt.AlignHCenter
                scale: 1.0
                anchors.fill: parent

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        Qt.openUrlExternally("https://github.com/xZepyx/aelyx-shell")
                    }
                }
            }
        }

        // --- MAIN CENTER LAYOUT ---
        RowLayout {
            spacing: 5
            Layout.alignment: Qt.AlignCenter

            // --- BUTTONS ---
            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                StyledButton {
                    text: "View on GitHub"
                    icon: 'code'
                    onClicked: Qt.openUrlExternally("https://github.com/xZepyx/aelyx-shell")
                    topRightRadius: 5
                    bottomRightRadius: 5
                }
                StyledButton {
                    text: "Report Issue"
                    icon: "bug_report"
                    secondary: true
                    onClicked: Qt.openUrlExternally("https://github.com/xZepyx/aelyx-shell/issues")
                    topLeftRadius: 5
                    bottomLeftRadius: 5
                }
            }
        }
    }
}
