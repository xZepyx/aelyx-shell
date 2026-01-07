import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.functions
import qs.services
import qs.widgets

Scope {
    property var settingsWindow: null

    IpcHandler {
        function open(menu: string) {
            Globals.states.settingsOpen = true;
            if (menu !== "" && settingsWindow !== null) {
                for (var i = 0; i < settingsWindow.menuModel.length; i++) {
                    var item = settingsWindow.menuModel[i];
                    if (!item.header && item.label.toLowerCase() === menu.toLowerCase()) {
                        settingsWindow.selectedIndex = item.page;
                        break;
                    }
                }
            }
        }

        target: "settings"
    }

    LazyLoader {
        active: Globals.states.settingsOpen

        Window {
            // header

            id: root

            property int selectedIndex: 0
            property bool sidebarCollapsed: false

            width: 1280
            height: 720
            visible: true
            title: "Settings - Nucleus Shell"
            color: Appearance.m3colors.m3background
            onClosing: Globals.states.settingsOpen = false
            Component.onCompleted: settingsWindow = root
        }

        // WIP 

    }

}
