import qs.config 
import qs.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore 
import Quickshell
import Quickshell.Widgets
import QtQuick.Effects

Item {
    Layout.fillHeight: true 
    Layout.fillWidth: true
    
    opacity: visible ? 1 : 0
    scale: visible ? 1 : 0.95

    Behavior on opacity {
        NumberAnimation { duration: Appearance.animation.durations.normal; easing.type: Easing.InOutExpo }
    }

    Behavior on scale {
        NumberAnimation { 
            duration: Appearance.animation.durations.normal
            easing.type: Easing.InOutExpo 
        }
    }

    // --- MAIN CENTER LAYOUT ---
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 5
        Layout.alignment: Qt.AlignHCenter

        // --- ICON ---
        Image {
            id: icon
            source: StandardPaths.writableLocation(StandardPaths.ConfigLocation)
                + "/quickshell/defaults/user/aelyx-logo.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            Layout.alignment: Qt.AlignHCenter
            scale: 1.0

            MultiEffect {
                anchors.fill: icon
                source: icon
                colorization: Config.options.appearance.theme === "light" ? 1.0 : 0.0
                colorizationColor: "black"
            }

            Behavior on scale {
                SpringAnimation {
                    spring: 5
                    damping: 0.1
                    mass: 0.5
                    epsilon: 0.01
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: icon.scale = 1.1
                onExited: icon.scale = 1.0

                onPressed: icon.scale = 0.95
                onReleased: icon.scale = 1.1

                onClicked: {
                    Qt.openUrlExternally("https://github.com/xZepyx/aelyx-shell")
                }
            }
        }

        // --- TITLE ---
        StyledText {
            text: "Aelyx Shell"
            font.pixelSize: 24
            font.family: "Outfit ExtraBold"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 400
        }

        // --- DESCRIPTION ---
        StyledText {
            text: "A curated configuration made for hyprland."
            font.pixelSize: 14
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 400
        }

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

    // --- FOOTER ---
    StyledText {
        text: "Built on top of <a href='https://quickshell.org'>Quickshell</a>"
        font.pixelSize: 12
        textFormat: Text.RichText
        horizontalAlignment: Text.AlignHCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        onLinkActivated: Qt.openUrlExternally(link)
    }
}
