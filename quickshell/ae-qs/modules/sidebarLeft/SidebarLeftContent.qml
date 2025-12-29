import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.functions
import qs.services
import qs.settings
import qs.widgets

Item {
    anchors.fill: parent

    SwipeView {
        id: view

        anchors.fill: parent
        interactive: true

        SystemOverview {
        }

        WallpapersPage {
        }

    }

    Rectangle {
        height: 2
        width: parent.width - Appearance.margin.verylarge
        color: Appearance.m3colors.m3outlineVariant
        opacity: 0.6

        anchors {
            top: view.top
            topMargin: segmentedIndicator.height + Appearance.margin.verysmall
            horizontalCenter: view.horizontalCenter
        }

    }

    Rectangle {
        id: activeTabIndicator

        height: 2
        width: 96
        radius: 1
        color: Appearance.m3colors.m3primary
        x: (segmentedIndicator.width / view.count) * view.currentIndex + (segmentedIndicator.width / view.count - width) / 2

        anchors {
            top: segmentedIndicator.bottom
            topMargin: Appearance.margin.verysmall
        }

        Behavior on x {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }

        }

    }

    Item {
        id: segmentedIndicator

        height: 56
        width: parent.width

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        Row {
            anchors.fill: parent
            spacing: 0

            Repeater {
                model: [{
                    "icon": "overview",
                    "text": "Overview"
                }, {
                    "icon": "wallpaper",
                    "text": "Wallpapers"
                }]

                Item {
                    width: segmentedIndicator.width / view.count
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: view.currentIndex = index
                    }

                    // Icon (true center)
                    MaterialSymbol {
                        icon: modelData.icon
                        iconSize: Appearance.font.size.huge
                        color: view.currentIndex === index ? Appearance.m3colors.m3primary : Appearance.m3colors.m3onSurfaceVariant

                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            topMargin: 12
                        }

                    }

                    // Label (independent centering)
                    StyledText {
                        text: modelData.text
                        font.pixelSize: Appearance.font.size.large
                        font.weight: Font.Medium
                        color: view.currentIndex === index ? Appearance.m3colors.m3primary : Appearance.m3colors.m3onSurfaceVariant

                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 0
                        }

                    }

                }

            }

        }

    }

}
