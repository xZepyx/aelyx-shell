pragma Singleton
pragma ComponentBehavior: Bound

import qs.functions
import QtQuick
import Quickshell

Singleton {
    id: root

    // Output flags
    property bool isHyprland: false
    property bool isNiri: false
    property string compositor: "unknown"

    // Environment checks
    readonly property string hyprlandSignature: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")
    readonly property string niriSocket: Quickshell.env("NIRI_SOCKET")

    Component.onCompleted: detectCompositor()

    function detectCompositor() {
        // --- Hyprland ---
        if (hyprlandSignature && hyprlandSignature.length > 0) {
            isHyprland = true
            isNiri = false
            compositor = "hyprland"
            console.info("Detected Hyprland")
            return
        }

        // --- Niri (verify socket exists) ---
        if (niriSocket && niriSocket.length > 0) {
            Proc.runCommand("niriCheck", ["test", "-S", niriSocket], (o, exit) => {
                if (exit === 0) {
                    isNiri = true
                    isHyprland = false
                    compositor = "niri"
                    console.info("Detected Niri")
                    return
                }
            })
            return
        }

        // --- Nothing found ---
        isHyprland = false
        isNiri = false
        compositor = "unknown"
        console.warn("No compositor detected (Hyprland/Niri)")
    }
}

// pain I died porting this to niri 