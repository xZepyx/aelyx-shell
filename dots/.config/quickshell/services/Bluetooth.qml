pragma Singleton
import QtQuick 
import Quickshell.Io
import Quickshell 
import Quickshell.Bluetooth

Singleton {
    id: root 

    property bool enabled: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false
    property bool adapter: Bluetooth.defaultAdapter
    property string connectedDeviceId: "Connected"

    Timer {
        interval: 10000
        repeat: true 
        running: true 
        onTriggered: btNameProc.running = true
    }

    Process {
        id: btNameProc
        running: true
        command: ["sh", "-c", "bluetoothctl info | grep 'Name' | awk -F ': ' '{print $2}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                var deviceName = text.trim()
                root.connectedDeviceId = deviceName
            }
        }
    }
}
