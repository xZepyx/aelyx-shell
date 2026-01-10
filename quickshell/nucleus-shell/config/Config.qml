pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import QtCore
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string filePath: Directories.shellConfigPath
    property alias runtime: configOptionsJsonAdapter
    property bool initialized: false
    property int readWriteDelay: 50 // milliseconds
    property bool blockWrites: false

    function updateKey(nestedKey, value) {
        let keys = nestedKey.split(".");

        // start from the JsonAdapter alias
        let obj = root.runtime;
        if (!obj) {
            console.warn("Shell.updateKey: flags adapter not available yet for key", nestedKey);
            return;
        }

        // Traverse to the target parent object, creating intermediate objects if needed
        for (let i = 0; i < keys.length - 1; ++i) {
            let k = keys[i];
            if (obj[k] === undefined || obj[k] === null || typeof obj[k] !== "object") {
                obj[k] = {};
            }
            obj = obj[k];
            if (!obj) {
                console.warn("Shell.updateKey: failed to create/resolve parent for key", k);
                return;
            }
        }

        // Convert string boolean/numeric values to native types when safe
        let convertedValue = value;
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || (!isNaN(Number(trimmed)) && trimmed !== "")) {
                try {
                    convertedValue = JSON.parse(trimmed);
                } catch (e) {
                    convertedValue = value;
                }
            }
        }

        try {
            obj[keys[keys.length - 1]] = convertedValue;
        } catch (e) {
            console.warn("Config.updateKey: failed to set key", nestedKey, e);
        }
    }

    Timer {
        id: fileReloadTimer
        interval: root.readWriteDelay
        repeat: false
        onTriggered: {
            configFileView.reload();
        }
    }

    Timer {
        id: fileWriteTimer
        interval: root.readWriteDelay
        repeat: false
        onTriggered: {
            configFileView.writeAdapter();
        }
    }

    FileView {
        id: configFileView
        path: root.filePath
        watchChanges: true
        blockWrites: root.blockWrites
        onFileChanged: fileReloadTimer.restart()
        onAdapterUpdated: fileWriteTimer.restart()
        onLoaded: {
            root.initialized = true
        } 
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: configOptionsJsonAdapter

            property JsonObject appearance: JsonObject {
                property string theme: "dark"
                property bool tintIcons: false
                property JsonObject colors: JsonObject {
                    property string scheme: "scheme-neutral"
                    property bool runMatugenUserWide: false
                }
                property JsonObject background: JsonObject {
                    property bool enabled: true 
                    property url path: Directories.defaultsPath + "/default.jpg"
                    property JsonObject clock: JsonObject {
                        property bool enabled: true 
                        property string position: "bottom-left" // top-left, top-right, bottom-right, bottom-left
                    }
                    property JsonObject slideshow: JsonObject {
                        property bool enabled: false
                        property string folder: ""
                        property int interval: 5 // minutes
                        property bool includeSubfolders: true
                    }
                }
            }

            property JsonObject misc: JsonObject {
                property url pfp: Quickshell.env("HOME") + "/.face.icon"
            }

            property JsonObject notifications: JsonObject {
                property bool enabled: true 
                property bool doNotDisturb: false
                property string position: "center" // center, left(top), right(top)  
            }

            property JsonObject shell: JsonObject {
                property string version: "0.1.0"
                property string releaseChannel: "stable"
            }

            property JsonObject overlays: JsonObject {
                property bool enabled: true 
                property bool volumeOverlayEnabled: true 
                property bool brightnessOverlayEnabled: true
                property string volumeOverlayPosition: "top" // top, top-left, top-right, bottom, bottom-left, bottom-right
                property string brightnessOverlayPosition: "top" // top, top-left, top-right, bottom, bottom-left, bottom-right
            }

            property JsonObject launcher: JsonObject {
                property bool fuzzySearchEnabled: true
                property string webSearchEngine: "google"
            }

            property JsonObject bar: JsonObject {
                property string position: "top" // left, right, top and bottom
                property bool enabled: true
                property bool merged: false
                property bool floating: false
                property bool gothCorners: true
                property int radius: Appearance.rounding.large
                property int margins: Appearance.margin.normal
                property int density: 50
                property JsonObject modules: JsonObject {
                    property int radius: Appearance.rounding.normal
                    property int height: 34
                    property JsonObject workspaces: JsonObject {
                        property bool enabled: true
                        property int workspaceIndicators: 8
                        property bool showAppIcons: true 
                        property bool showJapaneseNumbers: false
                    }
                    property JsonObject statusIcons: JsonObject {
                        property bool enabled: true
                        property bool networkStatusEnabled: true 
                        property bool bluetoothStatusEnabled: true 
                        property bool keyboardLayoutStatusEnabled: false
                        property bool themeStatusEnabled: true
                    }
                    property JsonObject systemUsage: JsonObject {
                        property bool enabled: true
                        property bool cpuStatsEnabled: true 
                        property bool memoryStatsEnabled: true 
                        property bool tempStatsEnabled: true
                    }
                }
            }
        }
    }
}
