import qs.config
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
            const currentTheme = Config.options.appearance.theme

            // Determine the new theme
            const newTheme = currentTheme === "light" ? "dark" : "light"

            // Set the new theme
            Config.setNestedValue("appearance.theme", newTheme)

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
            "~/.config/quickshell/scripts/background/gencolors.sh " +
            Config.options.background.wallpaperPath + " " +
            Config.options.global.colorScheme + " " +
            Config.options.appearance.theme
        ]
    }

}