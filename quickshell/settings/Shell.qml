pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import QtCore
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string filePath: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.local/share/aelyx/user/config.json"
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

            property JsonObject misc: JsonObject {
                property bool notificationDaemonEnabled: true
                property bool dndEnabled: false
                property url pfp: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.local/share/aelyx/defaults/pfp.png"
            }

            property JsonObject background: JsonObject {
                property bool wallpaperEnabled: true
                property url wallpaperPath: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.local/share/aelyx/defaults/wallpaper.jpg"
                property bool borderEnabled: false
                property string clockTimeFormat: "hh:mm"
                property int clockX: 100
                property int clockY: 100
                property bool showClock: true
            }

            property JsonObject bar: JsonObject {
                property bool atTop: true
                property bool floating: true
                property bool gothCorners: true
                property bool floatingModules: false
                property bool separatedIslands: true
                property bool enabled: true
                property int radius: Appearance.rounding.normal
                property int moduleRadius: Appearance.rounding.normal
                property int islandRadius: Appearance.rounding.large
                property int height: 50
                property int width: 1080
                property string _comment_: "Style values are not in use rn."
                property JsonObject modules: JsonObject {
                    property JsonObject systemTray: JsonObject {
                        property bool enabled: true 
                        property string position: "right"
                        property int style: 1
                    }
                    property JsonObject media: JsonObject {
                        property bool enabled: true 
                        property string position: "center"
                        property int style: 1
                    }
                    property JsonObject bluetoothWifi: JsonObject {
                        property bool enabled: true 
                        property string position: "right"
                        property int style: 1
                    }
                    property JsonObject network: JsonObject {
                        property bool enabled: true 
                        property string position: "right"
                        property int style: 1
                    }
                    property JsonObject userHostname: JsonObject {      
                        property bool enabled: true 
                        property string position: "left"
                        property int style: 1
                    }
                    property JsonObject activeTopLevel: JsonObject {
                        property bool enabled: true 
                        property string position: "center"
                        property int style: 1
                    }
                    property JsonObject clock: JsonObject {
                        property bool enabled: true 
                        property string position: "right"
                        property int style: 1
                    }
                    property JsonObject launcherToggle: JsonObject {
                        property bool enabled: true 
                        property string position: "right"
                        property int style: 1                        
                    }
                    property JsonObject powerMenuToggle: JsonObject {
                        property bool enabled: true 
                        property string position: "right"
                        property int style: 1                        
                    }
                    property JsonObject workspaces: JsonObject {
                        property bool enabled: true 
                        property int numWorkspaces: 8
                        property bool largeIcons: false
                        property bool showNumbers: true
                        property string position: "left"
                        property int style: 1
                    }
                }
            }
        }
    }
}