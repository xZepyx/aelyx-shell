import qs.core.appearance
import qs.core.config
import qs.services
import qs.common.widgets
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
    property int numWorkspaces: Config.options.bar.modules.workspaces.visibleWorkspaces

    // let layout determine size naturally
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    // --- Background ---
    Rectangle {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: Appearance.rounding.normal

        implicitWidth: workspaceRow.implicitWidth + Appearance.margin.large - 2
        implicitHeight: Config.options.bar.modules.workspaces.largeWorkspacesIcon ? workspaceRow.implicitHeight + Appearance.margin.large - 8.5 : workspaceRow.implicitHeight + Appearance.margin.large - 2

        MouseArea {
            anchors.fill: parent 
            onClicked: SessionState.overviewOpen = !SessionState.overviewOpen
        }

        Row {
            id: workspaceRow
            anchors.centerIn: parent
            spacing: Config.options.bar.modules.workspaces.largeWorkspacesIcon ? 4 : 5

            Repeater {
                model: numWorkspaces

                Rectangle {
                    id: wsBox
                    width: Config.options.bar.modules.workspaces.largeWorkspacesIcon
                        ? ((index + 1) === Hyprland.focusedWorkspaceId ? 46 : 24)
                        : ((index + 1) === Hyprland.focusedWorkspaceId ? 44 : 12)

                    height: Config.options.bar.modules.workspaces.largeWorkspacesIcon ? 20 : 12
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
                        visible: Config.options.bar.modules.workspaces.showNumbers && Config.options.bar.modules.workspaces.largeWorkspacesIcon
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
