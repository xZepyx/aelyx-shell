import Quickshell
import QtQuick
import Quickshell.Io
pragma Singleton

Item {
    id: root
    property string albumArtist: ""
    property string artUrl: ""
    property string albumTitle: "No Media"

    property int positionSec: 0
    property int lengthSec: 0

    function formatTime(seconds) {
        const m = Math.floor(seconds / 60)
        const s = Math.floor(seconds % 60)
        return `${m.toString().padStart(2,"0")}:${s.toString().padStart(2,"0")}`
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: artProc.running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            posProcess.running = true
            lenProcess.running = true
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: artistProc.running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: titleProc.running = true
    }

    Process {
        id: artProc
        command: ["playerctl", "metadata", "mpris:artUrl"]
        stdout: StdioCollector {
            onStreamFinished: {
                // sanitize output (remove newlines/spaces)
                var cleanUrl = text.trim()
                if (cleanUrl !== root.artUrl)
                    root.artUrl = cleanUrl
            }
        }
    }

    Process {
        id: artistProc
        command: ["playerctl", "metadata", "xesam:artist"]
        stdout: StdioCollector {
            onStreamFinished: {
                var cleanedArtist = text.trim()
                if (cleanedArtist !== "")
                root.albumArtist = cleanedArtist
                else root.albumArtist = "No Artist"
            }
        }
    }

    Process {
        id: titleProc
        command: ["playerctl", "metadata", "xesam:title"]
        stdout: StdioCollector {
            onStreamFinished: {
                var cleanedtitle = text.trim()
                if (cleanedtitle !== "")
                root.albumTitle = cleanedtitle
                else root.albumTitle = "No Media"


            }
        }
    }

    Process {
        id: posProcess
        command: ["playerctl", "position"]
        stdout: StdioCollector {
            onStreamFinished: {
                let val = parseFloat(text.trim())
                if (!isNaN(val))
                    root.positionSec = val
            }
        }
    }

    Process {
        id: lenProcess
        command: ["playerctl", "metadata", "mpris:length"]
        stdout: StdioCollector {
            onStreamFinished: {
                let val = parseFloat(text.trim())
                if (!isNaN(val))
                    root.lengthSec = val / 1000000
            }
        }
    }
}