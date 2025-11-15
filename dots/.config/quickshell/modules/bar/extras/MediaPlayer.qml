import qs.core.appearance
import qs.core.config
import qs.common.widgets
import qs.common.functions
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: mediaPlayer
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.ready && !SessionState.controlCenterOpen

    color: "transparent"
    focusable: true
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1


    property real mediaPlayerWidth: 450
    property real mediaPlayerHeight: 180

    implicitWidth: mediaPlayerWidth
    implicitHeight: mediaPlayerHeight

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
    }

    mask: Region {
        item: overlay
        intersection: SessionState.mediaPlayerOpen ? Intersection.Combine : Intersection.Xor
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "transparent"
        opacity: SessionState.mediaPlayerOpen ? 1 : 0
        Behavior on opacity { Anim {} }

        MouseArea {
            anchors.fill: parent
            enabled: SessionState.mediaPlayerOpen
            onClicked: SessionState.mediaPlayerOpen = false
        }
    }

    Item {
        id: keyCatcher
        anchors.fill: parent
        focus: SessionState.mediaPlayerOpen
        Keys.onEscapePressed: SessionState.mediaPlayerOpen = false
    }

    MergedEdgeRect {
        id: container
        visible: implicitHeight > 0
        color: Appearance.m3colors.m3background
        cornerRadius: Appearance.rounding.verylarge
        implicitWidth: mediaPlayer.mediaPlayerWidth
        implicitHeight: SessionState.mediaPlayerOpen ? mediaPlayer.mediaPlayerHeight : 0

        Behavior on implicitHeight { Anim {} }

        anchors {
            right: parent.right
            rightMargin: Config.options.background.borderEnabled ? Appearance.margin.tiny + 2 : 0
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        states: [
            State {
                name: "mpAtBottom"
                when: Config.options.bar.position === 2
                AnchorChanges {
                    target: container
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "mpAtTop"
                when: Config.options.bar.position === 1
                AnchorChanges {
                    target: container
                    anchors.bottom: undefined
                    anchors.top: parent.top
                }
            }
        ]

        content: Item {
            anchors.fill: parent

            Rectangle {
                id: artImage
                width: 100
                height: 100
                color: Appearance.m3colors.m3paddingContainer
                radius: Appearance.rounding.small
                anchors.verticalCenter: parent.verticalCenter
                opacity: SessionState.mediaPlayerOpen ? 1 : 0
                Behavior on opacity { Anim {} }
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: artImage.width
                        height: artImage.height
                        radius: artImage.radius
                    }
                }

                Image {
                    anchors.fill: parent
                    source: Mpris.artUrl
                    fillMode: Image.PreserveAspectCrop
                    cache: true
                    opacity: 0.9
                }
            }

            ColumnLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    leftMargin: 120
                    rightMargin: 20
                    bottomMargin: 50
                }
                spacing: 2

                StyledText {
                    id: albumTitle
                    text: Stringify.shortText(Mpris.albumTitle)
                    horizontalAlignment: Text.AlignLeft
                    Layout.fillWidth: true
                    font.family: "Pacifico"
                }

                StyledText {
                    id: albumArtist
                    text: Stringify.shortText(Mpris.albumArtist)
                    font.family: "Pacifico"
                    horizontalAlignment: Text.AlignLeft
                    Layout.fillWidth: true
                }

                StyledSlider {
                    id: lengthSlider
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    Layout.bottomMargin: -Appearance.margin.verylarge 
                    from: 0
                    to: Mpris.lengthSec
                    value: Mpris.positionSec
                    stepSize: 0.1

                    onMoved: seekProcess.running = true
                }
            }

            RowLayout {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    left: parent.left
                    rightMargin: 20
                    bottomMargin: 60
                }

                spacing: 10

                Rectangle {
                    id: playPauseButton
                    radius: 30
                    height: 36
                    width: 36
                    color: Appearance.m3colors.m3paddingContainer
                    Layout.alignment: Qt.AlignRight

                    property bool isPlaying: false

                    MaterialSymbol {
                        anchors.centerIn: parent
                        font.pixelSize: 25
                        text: playPauseButton.isPlaying ? "pause" : "play_arrow"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            toggleProcess.running = true
                            updateStatusProcess.running = true
                        }
                    }

                    Process {
                        id: toggleProcess
                        command: ["playerctl", "play-pause"]
                    }

                    Process {
                        id: seekProcess
                        command: ["playerctl", "position", lengthSlider.value.toString()]
                    }

                    Process {
                        id: updateStatusProcess
                        command: ["playerctl", "status"]
                        stdout: StdioCollector {
                            onStreamFinished: {
                                let s = text.trim().toLowerCase()
                                playPauseButton.isPlaying = (s === "playing")
                            }
                        }
                    }

                    Timer {
                        interval: 500
                        running: true
                        repeat: true
                        onTriggered: updateStatusProcess.running = true
                    }
                }
            }
        }
    }

    // --- Toggle logic ---
    function togglemediaPlayer() {
        const newState = !SessionState.mediaPlayerOpen
        SessionState.mediaPlayerOpen = newState
        if (newState)
            mediaPlayer.forceActiveFocus()
        else
            mediaPlayer.focus = false
    }

    IpcHandler {
        target: "mediaPlayer"
        function toggle() {
            togglemediaPlayer()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            mediaPlayer.monitor = Hyprland.focusedMonitor
        }
    }
}
