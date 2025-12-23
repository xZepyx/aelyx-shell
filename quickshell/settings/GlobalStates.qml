import QtQuick
pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell

Item {
    id: root

    property bool launcherOpen: false
    property bool powerMenuOpen: false
    property bool sidebarRightOpen: false
    property bool mediaPlayerOpen: false
    property bool windowOverviewOpen: false
    property bool osdNeeded: false
    property bool visible_settingsMenu: false 
    
}