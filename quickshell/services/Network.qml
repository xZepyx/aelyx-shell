pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property string connectedSsid: "No Internet"
    property int signalStrength: 0 // 0–100 %

    Timer {
        interval: 3000
        repeat: true
        running: true
        onTriggered: {
            connectedSsidProc.running = false
            connectedSsidProc.running = true
        }
    }

    Process {
        id: connectedSsidProc
        command: ["bash", "-c", "nmcli -t -f active,ssid,signal dev wifi | grep '^yes:'"]

        stdout: StdioCollector {
            onStreamFinished: {
                var output = text.trim()
                if (output.length > 0) {
                    var parts = output.split(":")
                    if (parts.length >= 3) {
                        var ssid = parts[1]
                        var strength = parseInt(parts[2])
                        root.connectedSsid = ssid || "No Internet"
                        root.signalStrength = isNaN(strength) ? 0 : strength
                        //console.log(`Wi-Fi: ${root.connectedSsid} (${root.signalStrength}%)`)
                    } else {
                        // malformed or unexpected output
                        root.connectedSsid = "No Internet"
                        root.signalStrength = 0
                        //console.log("Wi-Fi: No Internet")
                    }
                } else {
                    // no active connection
                    root.connectedSsid = "No Internet"
                    root.signalStrength = 0
                    //console.log("Wi-Fi: No Internet")
                }
            }
        }
    }
}
