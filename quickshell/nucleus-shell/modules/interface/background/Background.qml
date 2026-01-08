import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.services
import qs.modules.functions
import qs.modules.widgets

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: backgroundContainer

            required property var modelData
            property string selectedWallpaper: ""
            property string currentSource: Config.runtime.appearance.background.path // Current Wallpaper
            property string nextSource: "" // Wallpaper to be set

            function applyWallpaper() {
                if (!selectedWallpaper || selectedWallpaper === currentSource)
                    return ;

                nextSource = selectedWallpaper;
            }

            color: (currentImage.status === Image.Error) ? Appearance.colors.colLayer2 : "transparent" // To prevent showing nothing.
            WlrLayershell.namespace: "nucleus:background"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background
            screen: modelData
            visible: Config.initialized && Config.runtime.appearance.background.enabled

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            Process {
                id: wallpaperProc

                command: ["bash", "-c", Directories.scriptsPath + "/interface/changebg.sh"]

                stdout: StdioCollector {
                    onStreamFinished: {
                        const out = text.trim();
                        if (out !== "null" && out.length > 0) {
                            selectedWallpaper = out;
                            applyWallpaper();
                        }
                        Quickshell.execDetached(["qs", "-c", "nucleus-shell", "ipc", "call", "global", "regenColors"])
                    }
                }

            }

            Item {
                anchors.fill: parent

                Image {
                    id: currentImage

                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: currentSource
                    opacity: 1
                }

                Image {
                    id: nextImage

                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: nextSource
                    opacity: 0
                    onStatusChanged: {
                        if (status === Image.Ready && nextSource !== "")
                            fadeAnim.start(); // Fade animation

                    }
                }

                ParallelAnimation { // goofy-ahh animation
                    id: fadeAnim

                    onFinished: { // When finished change source
                        currentSource = nextSource;
                        nextSource = "";
                        currentImage.opacity = 1;
                        nextImage.opacity = 0;
                        Config.updateKey("appearance.background.path", currentSource);
                    }

                    NumberAnimation { // Fade Out
                        target: currentImage
                        property: "opacity"
                        to: 0
                        duration: 600
                        easing.type: Easing.InOutCubic
                    }

                    NumberAnimation { // Fade In
                        target: nextImage
                        property: "opacity"
                        to: 1
                        duration: 600
                        easing.type: Easing.InOutCubic
                    }

                }

                Item {
                    anchors.centerIn: parent
                    visible: currentImage.status === Image.Error

                    Rectangle {
                        width: 550
                        height: 400
                        radius: Appearance.rounding.windowRounding
                        color: "transparent" // It looks better somehow
                        anchors.centerIn: parent

                        ColumnLayout {
                            anchors.centerIn: parent
                            anchors.margins: Appearance.margin.normal
                            spacing: Appearance.margin.small

                            // Icon
                            MaterialSymbol {
                                text: "wallpaper"
                                font.pixelSize: Appearance.font.size.wildass
                                color: Appearance.colors.colOnLayer2
                                Layout.alignment: Qt.AlignHCenter
                            }

                            // Heading
                            StyledText {
                                text: "Wallpaper Missing"
                                font.pixelSize: Appearance.font.size.hugeass
                                font.bold: true
                                color: Appearance.colors.colOnLayer2
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignHCenter
                            }

                            // Description
                            StyledText {
                                text: "Seems like you haven't set a wallpaper yet."
                                font.pixelSize: Appearance.font.size.small
                                color: Appearance.colors.colSubtext
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Item {
                                Layout.fillHeight: true
                            }

                            // Action
                            StyledButton {
                                text: "Set wallpaper"
                                icon: "wallpaper"
                                secondary: true
                                radius: 22
                                Layout.alignment: Qt.AlignHCenter
                                onClicked: wallpaperProc.running = true
                            }

                        }

                    }

                }

            }

            Clock {
                imageFailed: currentImage.status === Image.Error
            }

            IpcHandler {
                function change() {
                    wallpaperProc.running = true;
                }

                function next() {
                    WallpaperSlideshow.nextWallpaper();
                }

                target: "background"
            }

        }

    }

}
