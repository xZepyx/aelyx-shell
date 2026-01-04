pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import QtCore
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string filePath: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/quickshell/aelyx-shell/config/runtime/settings.json"
    property alias flags: configOptionsJsonAdapter
    property bool ready: false
    property int readWriteDelay: 50 // milliseconds
    property bool blockWrites: false

    function setNestedValue(nestedKey, value) {
        let keys = nestedKey.split(".");

        // start from the JsonAdapter alias
        let obj = root.flags;
        if (!obj) {
            console.warn("Shell.setNestedValue: flags adapter not available yet for key", nestedKey);
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
                console.warn("Shell.setNestedValue: failed to create/resolve parent for key", k);
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
            console.warn("Shell.setNestedValue: failed to set key", nestedKey, e);
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
            root.ready = true
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
                property string colorScheme: "scheme-rainbow"
            }

            property JsonObject shellInfo: JsonObject {
                property string qsVersion: "0.2.1"
                property string version: "4.0.2"
                property string channel: "stable"
            }

            property JsonObject misc: JsonObject {
                property bool notificationDaemonEnabled: true
                property bool dndEnabled: false
                property url pfp: ""
                property bool openSidebarsOnHovered: true
                property bool showFirstTimeMenuOnStartup: true
            }

            property JsonObject background: JsonObject {
                property bool wallpaperEnabled: true
                property url wallpaperPath: ""
                property bool borderEnabled: false
                property string clockTimeFormat: "hh:mm"
                property string clockPosition: "bottom-left"
                property bool showClock: true
            }

            property JsonObject bar: JsonObject {
                property string position: "top"
                property bool floating: true
                property bool gothCorners: true
                property bool enabled: true
                property int radius: Appearance.rounding.normal
                property int moduleRadius: Appearance.rounding.normal
                property int islandRadius: Appearance.rounding.large
                property int density: 50
                property int width: 1080
                property JsonObject modules: JsonObject {
                    property JsonObject workspaces: JsonObject {
                        property int workspaceIndicators: 8
                    }
                }
            }
        }
    }
}
