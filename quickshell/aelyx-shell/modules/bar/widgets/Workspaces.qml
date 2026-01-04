import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.bar
import qs.services
import qs.functions
import qs.config
import qs.widgets

BarModule {
    id: workspaceContainer

    property int numWorkspaces: Shell.flags.bar.modules.workspaces.workspaceIndicators

    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    property var workspaceOccupied: []
    property var occupiedRanges: []

    function updateWorkspaceOccupied() {
        workspaceOccupied = Array.from(
            { length: numWorkspaces },
            (_, i) => Hyprland.isWorkspaceOccupied(i + 1)
        )

        const ranges = []
        let start = -1

        for (let i = 0; i < workspaceOccupied.length; i++) {
            if (workspaceOccupied[i]) {
                if (start === -1)
                    start = i
            } else if (start !== -1) {
                if (i - 1 > start)
                    ranges.push({ start, end: i - 1 })
                start = -1
            }
        }

        if (start !== -1 && workspaceOccupied.length - 1 > start)
            ranges.push({ start, end: workspaceOccupied.length - 1 })

        occupiedRanges = ranges
    }

    Component.onCompleted: updateWorkspaceOccupied()

    Connections {
        target: Hyprland
        function onWindowListChanged() {
            updateWorkspaceOccupied()
        }
    }


    Rectangle {
        id: bgRect

        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius
        implicitWidth: workspaceRow.implicitWidth + Appearance.margin.large - 8
        implicitHeight: workspaceRow.implicitHeight + Appearance.margin.normal - 8

        Item {
            id: occupiedStretchLayer
            anchors.centerIn: workspaceRow
            width: workspaceRow.width
            height: 26
            z: 0

            Repeater {
                model: occupiedRanges

                Rectangle {
                    height: 26
                    radius: 14
                    color: ColorModifier.mix(Appearance.m3colors.m3tertiary, Appearance.m3colors.m3surfaceContainerLowest)
                    opacity: 0.8

                    x: modelData.start * (26 + workspaceRow.spacing)
                    width: (modelData.end - modelData.start + 1) * 26
                        + (modelData.end - modelData.start) * workspaceRow.spacing
                }
            }
        }

        Rectangle {
            id: highlight
            property int index: Hyprland.focusedWorkspaceId - 1
            property real itemWidth: 26
            property real spacing: workspaceRow.spacing
            property real targetX: Math.min(index, numWorkspaces - 1) * (itemWidth + spacing) + 7

            // Animated endpoints
            property real animatedX1: targetX
            property real animatedX2: targetX

            x: Math.min(animatedX1, animatedX2)
            y: 4
            width: Math.abs(animatedX2 - animatedX1) + itemWidth
            height: 26
            radius: 13
            color: Appearance.m3colors.m3tertiary


            Behavior on animatedX1 {
                NumberAnimation {
                    duration: Appearance.animation.durations.fast
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on animatedX2 {
                NumberAnimation {
                    duration: Appearance.animation.durations.large
                    easing.type: Easing.OutCubic
                }
            }

            onTargetXChanged: {
                animatedX1 = targetX
                animatedX2 = targetX
            }

            // Update highlight when workspace changes
            Connections {
                target: Hyprland
                function onWorkspaceChanged(wsId) {
                    highlight.index = wsId - 1
                    highlight.targetX = highlight.index * (highlight.itemWidth + highlight.spacing)
                }
            }
        }

        RowLayout {
            id: workspaceRow

            anchors.centerIn: parent
            spacing: 10

            Repeater {
                model: numWorkspaces

                Item {
                    property bool focused: (index + 1) === Hyprland.focusedWorkspaceId
                    property bool occupied: Hyprland.isWorkspaceOccupied(index + 1)

                    width: 26
                    height: 26


                    IconImage {
                        id: appIcon
                        visible: Shell.flags.bar.modules.workspaces.showAppIcons
                        anchors.centerIn: parent
                        implicitSize: 20
                        rotation: (Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right") ? 270 : 0
                        source: {
                            const win = Hyprland.focusedWindowForWorkspace(index + 1)
                            return win ? Quickshell.iconPath(Utils.resolveIcon(win.class)) : ""
                        }
                    }

                    Tint {
                        rotation: (Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right") ? 270 : 0
                        sourceItem: appIcon
                        anchors.fill: appIcon
                    }

                    MaterialSymbol {
                        visible: true
                        id: symbol
                        animate: false
                        anchors.centerIn: parent
                        
                        text: Shell.flags.bar.modules.workspaces.showAppIcons ? (!occupied ? "fiber_manual_record" : "") : (occupied  || focused ? "󰮯" : "fiber_manual_record")
                        
                        font.variableAxes: { 
                            "FILL": (symbol.text === "fiber_manual_record") ? 1.0 : 0.0 
                        }

                        rotation: (Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right") ? 270 : 0
                        font.pixelSize: (symbol.text === "fiber_manual_record") ? 10 : Appearance.font.size.large
                        color: focused ? Appearance.m3colors.m3shadow : Appearance.m3colors.m3secondary
                    }


                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }

                }

            }

        }

    }

}
