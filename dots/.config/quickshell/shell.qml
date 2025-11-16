import qs.bin
import qs.modules.bar
import qs.modules.background
import qs.modules.controlCenter
import qs.modules.border
import qs.modules.launcher
import qs.modules.overlays
import qs.modules.powerMenu

import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {

    // Initiate shell
    BorderWindow {}
    Bar {}
    PowerMenu{}
    LauncherWindow{}
    Background{}
    GlobalProcesses{}
    ControlCenter{}
    Overlays{}

}
