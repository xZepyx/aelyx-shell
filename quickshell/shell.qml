import qs.settings
import qs.modules.bar
import qs.modules.background
import qs.modules.launcher
import qs.modules.overlays
import qs.modules.notifications
import qs.modules.sidebarRight
import qs.modules.settings
import qs.modules.powerMenu

import QtQuick 
import Quickshell  

ShellRoot {
    GlobalProcesses{}
    Background{}
    Bar{}
    Launcher{}
    Overlays{}
    Notification{}
    SidebarRight{}
    Settings{}
    PowerMenu{}
}