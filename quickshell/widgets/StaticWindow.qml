import Quickshell
import Quickshell.Wayland 
import QtQuick 

PanelWindow {
    id: panel 
    property string namespace: ""
    color: "transparent"
    WlrLayershell.namespace: namespace 
}