pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import QtCore
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string filePath: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/aelyxshell/config.json"
    property alias options: configOptionsJsonAdapter
    property bool ready: false
    property int readWriteDelay: 50 // milliseconds
    property bool blockWrites: false

    function setNestedValue(nestedKey, value) {
        let keys = nestedKey.split(".");
        let obj = root.options;
        let parents = [obj];

        // Traverse and collect parent objects
        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            parents.push(obj);
        }

        // Convert value to correct type using JSON.parse when safe
        let convertedValue = value;
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
                try {
                    convertedValue = JSON.parse(trimmed);
                } catch (e) {
                    convertedValue = value;
                }
            }
        }

        obj[keys[keys.length - 1]] = convertedValue;
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
            property JsonObject bar: JsonObject {
                // === Base properties ===
                property int position: 1  // 1 - Top | 2 - Bottom //
                property int implicitHeight: 50  
                property bool autohide: false
                property int radius: Appearance.rounding.normal
                property bool enabled: true
                property string launcherToggleSymbol: "motion_play"
                property JsonObject modules: JsonObject {
                    property JsonObject workspaces: JsonObject {
                        property bool largeWorkspacesIcon: false
                        property bool showNumbers: false
                        property int visibleWorkspaces: 8
                    }
                    property JsonObject clock: JsonObject {
                        property string format: "hh:mm | dd/MM"
                    }
                }
            }

            property JsonObject global: JsonObject {
                property string colorScheme: "scheme-rainbow"
                property url pfp: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/quickshell/defaults/user/pfp.jpg"
            }

            property JsonObject appearance: JsonObject {
                property string theme: "dark"
                property string iconTheme: "Papirus"
                property string defaultAppIcon: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.local/aelyx/apps/icons/preferences.svg"
            }

            property JsonObject background: JsonObject {
                property url wallpaperPath: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/quickshell/defaults/background/default_wallpaper.png"
                property bool borderEnabled: false
                property string clockTimeFormat: "hh:mm"
                property int clockX: 100
                property int clockY: 100
                property bool showClock: true
            }
        }
    }
}
