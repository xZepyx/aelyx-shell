import qs.services
import qs.widgets 
import qs.settings
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts

ContentMenu {
    title: "Wallpaper"
    description: "Manage your wallpapers"

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
    }

    ContentCard {
        ClippingRectangle {
            id: wpContainer
            Layout.alignment: Qt.AlignHCenter
            width: root.screen.width / 2
            height: width * root.screen.height / root.screen.width
            radius: 10
            color: Appearance.m3colors.m3surfaceContainer

            StyledText {
                text: "Current Wallpaper:"
                font.pixelSize: 20
                font.bold: true
            }

            StyledRect {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                id: wpPreview
                anchors.fill: parent
                radius: 12
                color: Appearance.m3colors.m3paddingContainer
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: wpPreview.width
                        height: wpPreview.height
                        radius: wpPreview.radius
                    }
                }

                StyledText {
                    opacity: !Shell.flags.background.wallpaperEnabled ? 1 : 0
                    Behavior on opacity { Anim {} }
                    font.pixelSize: Appearance.font.size.title
                    text: "Wallpaper Manager Disabled"
                    anchors.centerIn: parent
                }
                Image {
                    opacity: Shell.flags.background.wallpaperEnabled ? 1 : 0
                    Behavior on opacity { Anim {} }
                    anchors.fill: parent
                    source: Shell.flags.background.wallpaperPath
                    fillMode: Image.PreserveAspectCrop
                    cache: true
                    opacity: 0.9
                }
            }
        }


        StyledButton {
            icon: "wallpaper"
            text: "Change Wallpaper"
            Layout.fillWidth: true 
            onClicked: Quickshell.execDetached(["qs", "ipc", "call", "background", "change"])
        }

        StyledSwitchOption {
            title: "Enabled";
            description: "Enabled or disable Aelyx wallpaper manager."
            prefField: "background.wallpaperEnabled"
        }
    }
}
