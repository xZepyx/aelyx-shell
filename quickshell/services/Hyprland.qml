pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

/**
 * Unified Hyprland data provider
 * Combines reactive Quickshell.Hyprland data + raw hyprctl JSON updates.
 * combined version of hyprland services from github.com/yannpelletier/twinshell and github.com/end-4/dots-hyprland
 */

Singleton {
    id: root

    // --- Reactive Quickshell.Hyprland data ---
    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    readonly property Toplevel activeToplevel: ToplevelManager.activeToplevel
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property int focusedWorkspaceId: focusedWorkspace?.id ?? 1

    // --- Additional parsed hyprctl data ---
    property var windowList: []
    property var windowByAddress: ({})
    property var addresses: []
    property var layers: ({})
    property var monitorsInfo: []
    property var workspacesInfo: []
    property var workspaceById: ({})
    property var workspaceIds: []
    property var activeWorkspaceInfo: null

    // --- Other info ---
    property string keyboardLayout: "?"

    // --- Dispatch wrapper ---
    function dispatch(request: string): void {
        Hyprland.dispatch(request)
    }

    // --- Simple helper ---
    function isWorkspaceOccupied(id: int): bool {
        return Hyprland.workspaces.values.find((w) => {
            return w?.id === id
        })?.lastIpcObject.windows > 0 || false
    }

    // --- Update functions (raw JSON) ---
    function updateAll() {
        getClients.running = true
        getLayers.running = true
        getMonitors.running = true
        getWorkspaces.running = true
        getActiveWorkspace.running = true
    }

    function biggestWindowForWorkspace(workspaceId) {
        const windowsInThisWorkspace = root.windowList.filter(w => w.workspace.id === workspaceId)
        return windowsInThisWorkspace.reduce((maxWin, win) => {
            const maxArea = (maxWin?.size?.[0] ?? 0) * (maxWin?.size?.[1] ?? 0)
            const winArea = (win?.size?.[0] ?? 0) * (win?.size?.[1] ?? 0)
            return winArea > maxArea ? win : maxWin
        }, null)
    }

    // --- Keyboard layout fetcher ---
    function refreshKeyboardLayout() {
        hyprctlDevices.running = true
    }

    // --- Processes ---
    Process {
        id: hyprctlDevices
        command: ["hyprctl", "devices", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const devices = JSON.parse(this.text)
                    const keyboard = devices.keyboards.find(k => k.main) || devices.keyboards[0]
                    if (keyboard && keyboard.active_keymap) {
                        root.keyboardLayout = keyboard.active_keymap.toUpperCase().slice(0, 2)
                    } else {
                        root.keyboardLayout = "?"
                    }
                } catch (err) {
                    console.error("Failed to parse keyboard layout:", err)
                    root.keyboardLayout = "?"
                }
            }
        }
    }

    Process {
        id: getClients
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.windowList = JSON.parse(this.text)
                    let tempWinByAddress = {}
                    for (let win of root.windowList) tempWinByAddress[win.address] = win
                    root.windowByAddress = tempWinByAddress
                    root.addresses = root.windowList.map(w => w.address)
                } catch (e) {
                    console.error("Failed to parse clients:", e)
                }
            }
        }
    }

    Process {
        id: getMonitors
        command: ["hyprctl", "monitors", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.monitorsInfo = JSON.parse(this.text)
                } catch (e) {
                    console.error("Failed to parse monitors:", e)
                }
            }
        }
    }

    Process {
        id: getLayers
        command: ["hyprctl", "layers", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.layers = JSON.parse(this.text)
                } catch (e) {
                    console.error("Failed to parse layers:", e)
                }
            }
        }
    }

    Process {
        id: getWorkspaces
        command: ["hyprctl", "workspaces", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.workspacesInfo = JSON.parse(this.text)
                    let map = {}
                    for (let ws of root.workspacesInfo) map[ws.id] = ws
                    root.workspaceById = map
                    root.workspaceIds = root.workspacesInfo.map(ws => ws.id)
                } catch (e) {
                    console.error("Failed to parse workspaces:", e)
                }
            }
        }
    }

    Process {
        id: getActiveWorkspace
        command: ["hyprctl", "activeworkspace", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.activeWorkspaceInfo = JSON.parse(this.text)
                } catch (e) {
                    console.error("Failed to parse active workspace:", e)
                }
            }
        }
    }

    // --- Live event connection ---
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name.endsWith("v2"))
                return

            if (event.name.includes("activelayout"))
                refreshKeyboardLayout()
            else if (event.name.includes("mon"))
                Hyprland.refreshMonitors()
            else if (event.name.includes("workspace") || event.name.includes("window"))
                Hyprland.refreshWorkspaces()
            else
                Hyprland.refreshToplevels()

            updateAll()
        }
    }

    Component.onCompleted: {
        updateAll()
        refreshKeyboardLayout()
    }
}
