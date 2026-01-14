import QtQuick
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import Quickshell.Widgets
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
        radius: Config.runtime.bar.modules.radius * Config.runtime.appearance.rounding.factor
        implicitWidth: isVertical ? row.implicitWidth + Appearance.margin.large - 10 : row.implicitWidth + Appearance.margin.large
        implicitHeight: Config.runtime.bar.modules.height

    }

    Row {
        id: row

        spacing: Appearance.margin.small
        anchors.centerIn: parent

        // Icon button with rounded background
        ClippingRectangle {
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
                source: (Mpris.artUrl !== "") ? Mpris.artUrl : Directories.assetsPath + "/svgs/music.svg"
                layer.enabled: true

                layer.effect: ColorOverlay {
                    color: Mpris.artUrl === "" ? Config.runtime.appearance.theme === "dark" ? '#b1a4a4' : "grey" : "transparent"
                    source: art
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Mpris.playPause()
                }
                hoverEnabled: true
                onEntered: iconButton.opacity = 1
                onExited: iconButton.opacity = 0.9
            }


            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 4000
                loops: Animation.Infinite
                running: Mpris.isPlaying && Config.runtime.appearance.animations.enabled
            }

        }


        StyledText {
            id: textItem

            text: StringUtils.shortText(Mpris.title, 16)
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0.2
            visible: !isVertical
        }

    }

}
