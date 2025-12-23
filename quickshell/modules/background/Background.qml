import qs.widgets 
import qs.settings
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "clock/"

Scope {
    id: root 
    Variants {
        model: Quickshell.screens 
        StaticWindow {
            required property var modelData
            id: backgroundContainer
            color: "transparent"
            namespace: "aelyx:background"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background
            screen: modelData
            visible: Shell.ready && Shell.flags.background.wallpaperEnabled

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            property string selectedWallpaper: ""
            property string pendingWallpaper: ""

            Process {
                id: wallpaperProc
                command: [
                    "bash", "-c",
                    "~/.local/share/aelyx/scripts/background/changebg.sh"
                ]

                stdout: StdioCollector {
                    onStreamFinished: {
                        const out = text.trim()
                        if (out !== "null" && out.length > 0) {
                            pendingWallpaper = out
                            preloadImage.source = pendingWallpaper
                            fadeOutAnim.start()
                        }
                    }
                }
            }

            Process {
                id: genColorsProc
                command: [
                    "bash", "-c",
                    "~/.local/share/aelyx/scripts/background/gencolors.sh " +
                    Shell.flags.background.wallpaperPath + " " +
                    Shell.flags.appearance.colorScheme + " " +
                    Shell.flags.appearance.theme
                ]
            }

            // main background
            Image {
                id: background
                anchors.fill: parent
                height: modelData.height
                width: modelData.width
                fillMode: Image.PreserveAspectCrop
                source: Shell.flags.background.wallpaperPath
                opacity: 1.0
            }

            // hidden preloader
            Image {
                id: preloadImage
                visible: false
                height: modelData.height
                width: modelData.width
                asynchronous: true
                cache: false
                fillMode: Image.PreserveAspectCrop
            }

            SequentialAnimation {
                id: fadeOutAnim

                // fade out
                NumberAnimation {
                    target: background
                    property: "opacity"
                    to: 0
                    duration: 400
                    easing.type: Easing.InOutQuad
                }

                // swap wallpaper only after fade-out completes AND preload ready
                ScriptAction {
                    script: {
                        if (preloadImage.status === Image.Ready) {
                            applyWallpaper()
                        } else {
                            preloadImage.statusChanged.connect(function handler() {
                                if (preloadImage.status === Image.Ready) {
                                    applyWallpaper()
                                    preloadImage.statusChanged.disconnect(handler)
                                }
                            })
                        }
                    }
                }

                // fade back in
                NumberAnimation {
                    target: background
                    property: "opacity"
                    to: 1
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
            }

            function applyWallpaper() {
                background.source = pendingWallpaper
                Shell.setNestedValue("background.wallpaperPath", pendingWallpaper)
                genColorsProc.running = true
            }

            Clock { }

            IpcHandler {
                target: "background"
                function change() {
                    wallpaperProc.running = true
                }
            }
        }

    }
}