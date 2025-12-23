import qs.settings
import qs.services
import qs.widgets
import qs.modules.bar
import QtQuick
import Quickshell
import QtQuick.Layouts

BarModule {
    id: workspaceContainer
    Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
    }

    // --- Properties ---
    property int numWorkspaces: Shell.flags.bar.modules.workspaces.numWorkspaces

    // let layout determine size naturally
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    // --- Background ---
    Rectangle {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius

        implicitWidth: workspaceRow.implicitWidth + Appearance.margin.large - 2
        implicitHeight: Shell.flags.bar.modules.workspaces.largeIcons ? workspaceRow.implicitHeight + Appearance.margin.large - 8.5 : workspaceRow.implicitHeight + Appearance.margin.large 


        Row {
            id: workspaceRow
            anchors.centerIn: parent
            spacing: Shell.flags.bar.modules.workspaces.largeIcons ? 4 : 5

            Repeater {
                model: numWorkspaces

                Rectangle {
                    id: wsBox
                    property int prefHeight: Shell.flags.bar.modules.workspaces.largeIcons ? 20 : 12
                    property int prefWidth: Shell.flags.bar.modules.workspaces.largeIcons ? ((index + 1) === Hyprland.focusedWorkspaceId ? 50 : 33) : ((index + 1) === Hyprland.focusedWorkspaceId ? 44 : 12)
                    width: prefWidth

                    height: prefHeight
                    radius: Appearance.rounding.small

                    Behavior on width { Anim {} }

                    // current state color (kept as a binding)
                    property color workspaceStateColor: {
                        const isFocused = (index + 1) === Hyprland.focusedWorkspaceId
                        const isOccupied = Hyprland.isWorkspaceOccupied(index + 1)

                        if (isFocused)
                            return Appearance.m3colors.m3secondary
                        else if (isOccupied)
                            return Qt.darker(Appearance.m3colors.m3secondary, 1.4)
                        else
                            return Appearance.m3colors.m3onSecondary
                    }

                    // keep color bound so it updates automatically when focus/occupation change
                    color: workspaceStateColor

                    // hover flag (we won't write to color directly)
                    property bool hovered: false

                    // translucent overlay for hover (doesn't break color binding)
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        z: 0
                        // overlay color: you can tweak opacity target below
                        color: Appearance.m3colors.m3secondary
                        opacity: wsBox.hovered ? 0.18 : 0.0
                        visible: true
                        Behavior on opacity { Anim { duration: 150 } }
                    }

                    StyledText {
                        visible: Shell.flags.bar.modules.workspaces.showNumbers && Shell.flags.bar.modules.workspaces.largeIcons
                        anchors.centerIn: parent
                        text: (index + 1).toString()
                        font.pixelSize: Appearance.font.size.small 
                    } 

                    // keep MouseArea last so it receives events reliably
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: wsBox.hovered = true
                        onExited: wsBox.hovered = false
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }
        }
    }
}
