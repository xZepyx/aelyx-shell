import qs.widgets
import qs.settings
import qs.modules.bar.widgets
import QtQuick
import QtQuick.Layouts

Item {

    StyledRect {
        anchors.centerIn: parent
        color: Appearance.m3colors.m3background
        opacity: Shell.flags.bar.floatingModules && Shell.flags.bar.floating ? 1.0 : 0
        width: centerRow.width + 20
        height: centerRow.height + 15
        radius: Shell.flags.bar.islandRadius
    }

    StyledRect {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        color: Appearance.m3colors.m3background
        opacity: Shell.flags.bar.floatingModules && Shell.flags.bar.floating ? 1.0 : 0
        width: rightRow.width + 15
        height: rightRow.height + 15
        radius: Shell.flags.bar.islandRadius
    }

    StyledRect {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
        color: Appearance.m3colors.m3background
        opacity: Shell.flags.bar.floatingModules && Shell.flags.bar.floating ? 1.0 : 0
        width: leftRow.width + 15
        height: leftRow.height + 15
        radius: Shell.flags.bar.islandRadius
    }

    Row {
        id: leftRow
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
    }

    Row {
        id: centerRow
        anchors.centerIn: parent
        spacing: 4
    }

    RowLayout {
        id: rightRow
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
    }


    //
    // ───────────────────────────────
    //  Choose row based on module pos
    // ───────────────────────────────
    //
    function rowFor(pos) {
        if (pos === "left")   return leftRow
        if (pos === "center") return centerRow
        return rightRow
    }

    Workspaces {
        id: mWorkspaces
        visible: Shell.flags.bar.modules.workspaces.enabled
        Binding {
            target: mWorkspaces
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.workspaces.position)
        }
    }

    UserHostname {
        id: mUserHostname
        visible: Shell.flags.bar.modules.userHostname.enabled
        Binding {
            target: mUserHostname
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.userHostname.position)
        }
    }

    Network {
        id: mNetwork
        visible: Shell.flags.bar.modules.network.enabled
        Binding {
            target: mNetwork
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.network.position)
        }
    }

    SystemTray {
        id: mSystemTray
        // visible only if there are items and enabled in settings 
        Binding {
            target: mSystemTray
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.systemTray.position)
        }
    }

    Media {
        id: mMedia
        visible: Shell.flags.bar.modules.media.enabled
        Binding {
            target: mMedia
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.media.position)
        }
    }

    BluetoothWifi {
        id: mBluetoothWifi
        visible: Shell.flags.bar.modules.bluetoothWifi.enabled
        Binding {
            target: mBluetoothWifi
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.bluetoothWifi.position)
        }
    }

    ActiveTopLevel {
        id: mActiveTopLevel
        visible: Shell.flags.bar.modules.activeTopLevel.enabled
        Binding {
            target: mActiveTopLevel
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.activeTopLevel.position)
        }
    }

    Clock {
        id: mClock
        visible: Shell.flags.bar.modules.clock.enabled
        Binding {
            target: mClock
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.clock.position)
        }
    }

    LauncherToggle {
        id: mLauncherToggle
        visible: Shell.flags.bar.modules.launcherToggle.enabled
        Binding {
            target: mLauncherToggle
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.launcherToggle.position)
        }
    }

    PowerMenuToggle {
        id: mPowerMenuToggle
        visible: Shell.flags.bar.modules.powerMenuToggle.enabled
        Binding {
            target: mPowerMenuToggle
            property: "parent"
            value: rowFor(Shell.flags.bar.modules.powerMenuToggle.position)
        }
    }

    Volume {}
    Brightness {}
}
