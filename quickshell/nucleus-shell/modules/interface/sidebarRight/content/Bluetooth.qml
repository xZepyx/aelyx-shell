import qs.config
import qs.modules.widgets
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts

StyledRect {
    id: root
    width: 200
    height: 80
    radius: Appearance.rounding.verylarge
    color: Appearance.m3colors.m3surfaceContainerHigh

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    // --- Service bindings ---
    readonly property bool adapterPresent: Bluetooth.defaultAdapter !== null
    readonly property bool enabled: Bluetooth.defaultAdapter?.enabled ?? false
    readonly property var activeDevice: Bluetooth.activeDevice

    readonly property string iconName: Bluetooth.icon

    readonly property string statusText: {
        if (!adapterPresent)
            return "No adapter";
        if (!enabled)
            return "Disabled";
        if (activeDevice)
            return activeDevice.name;
        return Bluetooth.defaultAdapter.discovering
            ? "Scanning…"
            : "Enabled";
    }

    // --- Icon background ---
    StyledRect {
        id: iconBg
        width: 50
        height: 50
        radius: Appearance.rounding.verylarge
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Appearance.margin.small

        color: {
            if (!enabled)
                return Appearance.m3colors.m3surfaceContainerHigh;
            if (activeDevice)
                return Appearance.m3colors.m3primaryContainer;
            return Appearance.m3colors.m3secondaryContainer;
        }

        MaterialSymbol {
            anchors.centerIn: parent
            iconSize: 35
            icon: iconName
        }
    }

    // --- Text ---
    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconBg.right
        anchors.leftMargin: Appearance.margin.small
        spacing: 2

        StyledText {
            text: "Bluetooth"
            font.pixelSize: Appearance.font.size.large
            elide: Text.ElideRight
            width: root.width - iconBg.width - 30
        }

        StyledText {
            text: statusText
            font.pixelSize: Appearance.font.size.small
            color: Appearance.m3colors.m3onSurfaceVariant
            elide: Text.ElideRight
            width: root.width - iconBg.width - 30
        }
    }

    // --- Interaction ---
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!adapterPresent)
                return;

            Bluetooth.defaultAdapter.enabled =
                !Bluetooth.defaultAdapter.enabled;
        }
    }
}
