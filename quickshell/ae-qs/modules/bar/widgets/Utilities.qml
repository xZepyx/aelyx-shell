import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.services
import qs.settings
import qs.widgets

BarModule {
    id: clockContainer

    Layout.alignment: Qt.AlignVCenter
    // Let the layout compute size automatically
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    Rectangle {
        id: bgRect

        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius
        // Padding around the text
        implicitWidth: child.implicitWidth + Appearance.margin.large
        implicitHeight: child.implicitHeight + Appearance.margin.verysmall
    }

    RowLayout {
        id: child

        anchors.centerIn: parent
        spacing: 6

        MaterialSymbolButton {
            icon: "screenshot_region"
            iconSize: Appearance.font.size.large + 4
            onButtonClicked: Quickshell.execDetached(["sh", "-c", "grim -g \"$(slurp)\" /tmp/shot.png && cp /tmp/shot.png ~/Pictures/Screenshots/screenshot-$(date +%s).png && wl-copy < /tmp/shot.png"])
        }

        MaterialSymbolButton {
            icon: "edit"
            iconSize: Appearance.font.size.large + 4
            onButtonClicked: Quickshell.execDetached(["hyprpicker"])
        }

        MaterialSymbolButton {
            icon: "terminal"
            iconSize: Appearance.font.size.large + 4
            onButtonClicked: Quickshell.execDetached(["kitty"])
        }

    }

}
