pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

// from github.com/end-4/dots-hyprland

Singleton {
    id: root
    signal brightnessChanged()

    property var ddcMonitors: []
    readonly property list<BrightnessMonitor> monitors: Quickshell.screens.map(screen => monitorComp.createObject(root, { screen }))

    function getMonitorForScreen(screen: ShellScreen): var {
        return monitors.find(m => m.screen === screen)
    }

    function increaseBrightness(): void {
        const focusedName = Hyprland.focusedMonitor.name
        const monitor = monitors.find(m => focusedName === m.screen.name)
        if (monitor)
            monitor.setBrightness(monitor.brightness + 0.05)
    }

    function decreaseBrightness(): void {
        const focusedName = Hyprland.focusedMonitor.name
        const monitor = monitors.find(m => focusedName === m.screen.name)
        if (monitor)
            monitor.setBrightness(monitor.brightness - 0.05)
    }

    reloadableId: "brightness"

    onMonitorsChanged: {
        ddcMonitors = []
        ddcProc.running = true
    }

    Process {
        id: ddcProc
        command: ["ddcutil", "detect", "--brief"]
        stdout: SplitParser {
            splitMarker: "\n\n"
            onRead: data => {
                if (data.startsWith("Display ")) {
                    const lines = data.split("\n").map(l => l.trim())
                    root.ddcMonitors.push({
                        model: lines.find(l => l.startsWith("Monitor:")).split(":")[2],
                        busNum: lines.find(l => l.startsWith("I2C bus:")).split("/dev/i2c-")[1]
                    })
                }
            }
        }
        onExited: root.ddcMonitorsChanged()
    }

    Process { id: setProc }

    component BrightnessMonitor: QtObject {
        id: monitor

        required property ShellScreen screen

        readonly property bool isDdc: {
            const match = root.ddcMonitors.find(m => m.model === screen.model &&
                !root.monitors.slice(0, root.monitors.indexOf(this))
                    .some(mon => mon.busNum === m.busNum))
            return !!match
        }

        readonly property string busNum: {
            const match = root.ddcMonitors.find(m => m.model === screen.model &&
                !root.monitors.slice(0, root.monitors.indexOf(this))
                    .some(mon => mon.busNum === m.busNum))
            return match?.busNum ?? ""
        }

        property int rawMaxBrightness: 100
        property real brightness
        property real brightnessMultiplier: 1.0
        property real multipliedBrightness: Math.max(0, Math.min(1, brightness * brightnessMultiplier))
        property bool ready: false
        property bool animateChanges: !monitor.isDdc

        onBrightnessChanged: {
            if (!monitor.ready) return
            root.brightnessChanged()
            if (monitor.animateChanges)
                syncBrightness()
            else
                setTimer.restart()
        }

        property var setTimer: Timer {
            id: setTimer
            interval: monitor.isDdc ? 300 : 0
            onTriggered: syncBrightness()
        }

        function initialize() {
            monitor.ready = false
            initProc.command = isDdc
                ? ["ddcutil", "-b", busNum, "getvcp", "10", "--brief"]
                : ["sh", "-c", `echo "a b c $(brightnessctl g) $(brightnessctl m)"`]
            initProc.running = true
        }

        readonly property Process initProc: Process {
            stdout: SplitParser {
                onRead: data => {
                    const [, , , current, max] = data.split(" ")
                    monitor.rawMaxBrightness = parseInt(max)
                    monitor.brightness = parseInt(current) / monitor.rawMaxBrightness
                    monitor.ready = true
                }
            }
        }

        function syncBrightness() {
            const brightnessValue = Math.max(Math.min(monitor.multipliedBrightness, 1), 0)
            const rawValueRounded = Math.max(Math.floor(brightnessValue * monitor.rawMaxBrightness), 1)
            setProc.command = isDdc
                ? ["ddcutil", "-b", busNum, "setvcp", "10", rawValueRounded]
                : ["brightnessctl", "set", rawValueRounded.toString()]
            setProc.startDetached()
        }

        function setBrightness(value: real): void {
            value = Math.max(0, Math.min(1, value))
            monitor.brightness = value
        }

        Component.onCompleted: initialize()
        onBusNumChanged: initialize()
    }

    Component { id: monitorComp; BrightnessMonitor {} }
}
