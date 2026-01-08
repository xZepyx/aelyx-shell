import qs.services
import qs.modules.widgets
import qs.config
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ContentMenu {
    title: "Wallpaper"
    description: "Manage your wallpapers"

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
    }

    // Interval options: value in minutes, display label
    property var intervalOptions: [
        {
            value: 5,
            label: "5 minutes"
        },
        {
            value: 15,
            label: "15 minutes"
        },
        {
            value: 30,
            label: "30 minutes"
        },
        {
            value: 60,
            label: "1 hour"
        },
        {
            value: 120,
            label: "2 hours"
        },
        {
            value: 360,
            label: "6 hours"
        }
    ]

    function getIntervalIndex(minutes) {
        for (let i = 0; i < intervalOptions.length; i++) {
            if (intervalOptions[i].value === minutes)
                return i;
        }
        return 0; // default to first option
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

            ClippingRectangle {
                id: wpPreview
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                anchors.fill: parent
                radius: 12
                color: Appearance.m3colors.m3paddingContainer
                layer.enabled: true

                StyledText {
                    opacity: !Config.runtime.appearance.background.enabled ? 1 : 0
                    Behavior on opacity {
                        Anim {}
                    }
                    font.pixelSize: Appearance.font.size.title
                    text: "Wallpaper Manager Disabled"
                    anchors.centerIn: parent
                }
                Image {
                    opacity: Config.runtime.appearance.background.enabled ? 1 : 0
                    Behavior on opacity {
                        Anim {}
                    }
                    anchors.fill: parent
                    source: Config.runtime.appearance.background.path
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
            onClicked: {
                Quickshell.execDetached(["qs", "-c", "nucleus-shell", "ipc", "call", "background", "change"]);
            }
        }

        StyledSwitchOption {
            title: "Enabled"
            description: "Enabled or disable built-in wallpaper daemon."
            prefField: "appearance.background.enabled"
        }
    }

    ContentCard {
        StyledText {
            text: "Wallpaper Slideshow"
            font.pixelSize: 20
            font.bold: true
        }

        StyledSwitchOption {
            title: "Enable Slideshow"
            description: "Automatically rotate wallpapers from a folder."
            prefField: "appearance.background.slideshow.enabled"
        }

        // Folder selection
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    StyledText {
                        text: "Wallpaper Folder"
                        font.pixelSize: 16
                    }

                    StyledText {
                        text: Config.runtime.appearance.background.slideshow.folder || "No folder selected"
                        font.pixelSize: 12
                        color: Appearance.m3colors.m3onSurfaceVariant
                        elide: Text.ElideMiddle
                        Layout.fillWidth: true
                    }
                }

                StyledButton {
                    icon: "folder_open"
                    text: "Browse"
                    onClicked: folderPickerProc.running = true
                }
            }

            // Wallpaper count info
            StyledText {
                visible: WallpaperSlideshow.wallpapers.length > 0
                text: WallpaperSlideshow.wallpapers.length + " wallpapers found"
                font.pixelSize: 12
                color: Appearance.m3colors.m3primary
            }

            StyledText {
                visible: WallpaperSlideshow.scanning
                text: "Scanning folder..."
                font.pixelSize: 12
                color: Appearance.m3colors.m3onSurfaceVariant
            }
        }

        // Interval selector
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                StyledText {
                    text: "Change Interval"
                    font.pixelSize: 16
                }

                StyledText {
                    text: "How often to change the wallpaper."
                    font.pixelSize: 12
                    color: Appearance.m3colors.m3onSurfaceVariant
                }
            }

            StyledDropDown {
                label: "Interval"
                model: intervalOptions.map(opt => opt.label)
                currentIndex: getIntervalIndex(Config.runtime.appearance.background.slideshow.interval)
                onSelectedIndexChanged: index => {
                    Config.updateKey("appearance.background.slideshow.interval", intervalOptions[index].value);
                }
            }
        }

        StyledSwitchOption {
            title: "Include Subfolders"
            description: "Also search for wallpapers in subfolders."
            prefField: "appearance.background.slideshow.includeSubfolders"
        }

        // Next wallpaper button
        StyledButton {
            icon: "skip_next"
            text: "Next Wallpaper"
            Layout.fillWidth: true
            enabled: WallpaperSlideshow.wallpapers.length > 0
            onClicked: {
                Quickshell.execDetached(["qs", "-c", "nucleus-shell", "ipc", "call", "background", "next"]);
            }
        }
    }

    // Folder picker process
    Process {
        id: folderPickerProc
        command: ["bash", Directories.scriptsPath + "/interface/selectfolder.sh", Config.runtime.appearance.background.slideshow.folder || Directories.pictures]

        stdout: StdioCollector {
            onStreamFinished: {
                const out = text.trim();
                if (out !== "null" && out.length > 0) {
                    Config.updateKey("appearance.background.slideshow.folder", out);
                }
            }
        }
    }
}
