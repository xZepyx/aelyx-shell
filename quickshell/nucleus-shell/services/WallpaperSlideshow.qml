pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property var wallpapers: []
    property bool scanning: false
    property string currentFolder: Config.initialized ? Config.runtime.appearance.background.slideshow.folder : ""
    property int intervalMinutes: Config.initialized ? Config.runtime.appearance.background.slideshow.interval : 5
    property bool enabled: Config.initialized ? Config.runtime.appearance.background.slideshow.enabled : false
    property bool includeSubfolders: Config.initialized ? Config.runtime.appearance.background.slideshow.includeSubfolders : true

    signal wallpaperChanged(string path)

    function nextWallpaper() {
        if (wallpapers.length === 0) {
            console.warn("WallpaperSlideshow: No wallpapers found in folder");
            return;
        }

        const randomIndex = Math.floor(Math.random() * wallpapers.length);
        const selectedPath = "file://" + wallpapers[randomIndex];
        
        Config.updateKey("appearance.background.path", selectedPath);
        wallpaperChanged(selectedPath);
        
        // Regenerate colors
        Quickshell.execDetached(["qs", "-c", "nucleus-shell", "ipc", "call", "global", "regenColors"]);
    }

    function scanFolder() {
        if (!currentFolder || currentFolder === "") {
            wallpapers = [];
            return;
        }
        
        scanning = true;
        scanProcess.running = true;
    }

    // Timer for automatic wallpaper rotation
    Timer {
        id: slideshowTimer
        interval: root.intervalMinutes * 60 * 1000 // Convert minutes to milliseconds
        repeat: true
        running: root.enabled && root.wallpapers.length > 0
        onTriggered: root.nextWallpaper()
    }

    // Process to scan folder for images
    Process {
        id: scanProcess
        
        command: root.includeSubfolders 
            ? ["find", root.currentFolder, "-type", "f", "-iregex", ".*\\.\\(jpg\\|jpeg\\|png\\|webp\\|bmp\\|svg\\)$"]
            : ["find", root.currentFolder, "-maxdepth", "1", "-type", "f", "-iregex", ".*\\.\\(jpg\\|jpeg\\|png\\|webp\\|bmp\\|svg\\)$"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                const lines = data.trim().split("\n").filter(line => line.length > 0);
                root.wallpapers = lines;
                root.scanning = false;
            }
        }

        onExited: (exitCode, exitStatus) => {
            root.scanning = false;
            if (exitCode !== 0) {
                console.warn("WallpaperSlideshow: Failed to scan folder");
                root.wallpapers = [];
            }
        }
    }

    // Watch for folder changes - rescan and immediately change wallpaper
    onCurrentFolderChanged: {
        if (currentFolder && currentFolder !== "") {
            // Rescan, then change wallpaper immediately after scan completes
            scanning = true;
            folderChangeScanProcess.running = true;
        } else {
            wallpapers = [];
        }
    }

    // Separate process for folder change scan (triggers immediate wallpaper change)
    Process {
        id: folderChangeScanProcess
        
        command: root.includeSubfolders 
            ? ["find", root.currentFolder, "-type", "f", "-iregex", ".*\\.\\(jpg\\|jpeg\\|png\\|webp\\|bmp\\|svg\\)$"]
            : ["find", root.currentFolder, "-maxdepth", "1", "-type", "f", "-iregex", ".*\\.\\(jpg\\|jpeg\\|png\\|webp\\|bmp\\|svg\\)$"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                const lines = data.trim().split("\n").filter(line => line.length > 0);
                root.wallpapers = lines;
                root.scanning = false;
                
                // Immediately change wallpaper when folder is changed
                if (root.wallpapers.length > 0) {
                    root.nextWallpaper();
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            root.scanning = false;
            if (exitCode !== 0) {
                console.warn("WallpaperSlideshow: Failed to scan folder");
                root.wallpapers = [];
            }
        }
    }

    // Watch for includeSubfolders changes
    onIncludeSubfoldersChanged: {
        if (currentFolder && currentFolder !== "") {
            scanFolder();
        }
    }

    // Initial scan when config is loaded
    Connections {
        target: Config
        function onInitializedChanged() {
            if (Config.initialized && root.currentFolder && root.currentFolder !== "") {
                root.scanFolder();
            }
        }
    }
}
