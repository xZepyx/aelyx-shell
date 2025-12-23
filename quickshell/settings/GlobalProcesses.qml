import qs.settings
import QtQuick
import Quickshell
import Quickshell.Io 


Scope {
    id: global
    // Handle Global Ipc's
    IpcHandler {
        target: "global"
        function toggleTheme() {
            // Get the current theme
            const currentTheme = Shell.flags.appearance.theme

            // Determine the new theme
            const newTheme = currentTheme === "light" ? "dark" : "light"

            // Set the new theme
            Shell.setNestedValue("appearance.theme", newTheme)

            genThemeColors.running = true

        }

        function regenColors() {
            genThemeColors.running = true
        }
    }

    Process {
        id: genThemeColors
        command: [
            "bash", "-c",
            "~/.local/share/aelyx/scripts/background/gencolors.sh \"$1\" \"$2\" \"$3\"",
            "_",  // $0 placeholder
            Shell.flags.background.wallpaperPath,
            Shell.flags.appearance.colorScheme,
            Shell.flags.appearance.theme
        ]
    }
}