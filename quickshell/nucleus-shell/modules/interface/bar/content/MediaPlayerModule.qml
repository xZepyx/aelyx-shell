import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.config
import qs.modules.functions
import qs.modules.widgets
import qs.services

Item {
    id: mediaPlayer

    property bool isVertical: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right")

    Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    Rectangle {
        id: bgRect

        color: Appearance.m3colors.m3paddingContainer
        radius: Config.runtime.bar.modules.radius
        implicitWidth: isVertical ? row.implicitWidth + Appearance.margin.large - 10 : row.implicitWidth + Appearance.margin.large
        implicitHeight: Config.runtime.bar.modules.height

        MouseArea {
            anchors.fill: parent
            onClicked: {
                GlobalStates.mediaPlayerOpen = !GlobalStates.mediaPlayerOpen;
                Qt.callLater(() => {
                    return GlobalStates.mediaPlayerOpen = GlobalStates.mediaPlayerOpen;
                });
            }
        }

    }

    Row {
        id: row

        property bool isPlaying: false

        spacing: Appearance.margin.small
        anchors.centerIn: parent

        // Icon button with rounded background
        Rectangle {
            id: iconButton

            width: 24
            height: 24
            radius: Config.runtime.bar.modules.radius / 1.2
            color: Appearance.colors.colLayer1Hover
            opacity: 1
            clip: true
            layer.enabled: true

            Image {
                id: art

                anchors.fill: parent
                source: Mpris.artUrl !== "" ? Mpris.artUrl : "../../../../assets/svgs/music.svg"
                layer.enabled: true

                layer.effect: ColorOverlay {
                    color: Mpris.artUrl === "" ? Config.runtime.appearance.theme === "dark" ? '#b1a4a4' : "grey" : "transparent"
                    source: art
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    toggleProcess.running = true;
                    updateStatusProcess.running = true;
                }
                hoverEnabled: true
                onEntered: iconButton.opacity = 1
                onExited: iconButton.opacity = 0.9
            }

            layer.effect: OpacityMask {

                maskSource: Rectangle {
                    width: iconButton.width
                    height: iconButton.height
                    radius: iconButton.width / 2
                }

            }

            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 4000
                loops: Animation.Infinite
                running: row.isPlaying
            }

        }

        // MPRIS Album Title
        StyledText {
            id: textItem

            text: StringUtils.shortText(Mpris.albumTitle, 16)
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0.2
            visible: !isVertical
        }

        // Play/pause toggle
        Process {
            id: toggleProcess

            command: ["playerctl", "play-pause"]
        }

        // Get current player status
        Process {
            id: updateStatusProcess

            command: ["playerctl", "status"]

            stdout: StdioCollector {
                onStreamFinished: {
                    let s = text.trim().toLowerCase();
                    row.isPlaying = (s === "playing");
                }
            }

        }

        // Poll every half second
        Timer {
            interval: 500
            running: true
            repeat: true
            onTriggered: updateStatusProcess.running = true
        }

    }

}
