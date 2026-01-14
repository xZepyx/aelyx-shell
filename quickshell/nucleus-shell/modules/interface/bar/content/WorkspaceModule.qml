import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.config
import qs.modules.functions
import qs.modules.widgets
import qs.services

Item {
    id: workspaceContainer

    property int numWorkspaces: Config.runtime.bar.modules.workspaces.workspaceIndicators
    property var workspaceOccupied: []
    property var occupiedRanges: []

    function japaneseNumber(num) {
        var kanjiMap = {
            "0": "零",
            "1": "一",
            "2": "二",
            "3": "三",
            "4": "四",
            "5": "五",
            "6": "六",
            "7": "七",
            "8": "八",
            "9": "九",
            "10": "十"
        };
        return kanjiMap[num] !== undefined ? kanjiMap[num] : "Number out of range";
    }

    function updateWorkspaceOccupied() {
        workspaceOccupied = Array.from({
            "length": numWorkspaces
        }, (_, i) => {
            return Hyprland.isWorkspaceOccupied(i + 1);
        });
        const ranges = [];
        let start = -1;
        for (let i = 0; i < workspaceOccupied.length; i++) {
            if (workspaceOccupied[i]) {
                if (start === -1)
                    start = i;

            } else if (start !== -1) {
                if (i - 1 > start)
                    ranges.push({
                    "start": start,
                    "end": i - 1
                });

                start = -1;
            }
        }
        if (start !== -1 && workspaceOccupied.length - 1 > start)
            ranges.push({
            "start": start,
            "end": workspaceOccupied.length - 1
        });

        occupiedRanges = ranges;
    }

    visible: Config.runtime.bar.modules.workspaces.enabled
    implicitWidth: bg.implicitWidth
    implicitHeight: Config.runtime.bar.modules.height
    Component.onCompleted: updateWorkspaceOccupied()

    Connections {
        function onWindowListChanged() {
            updateWorkspaceOccupied();
        }

        target: Hyprland
    }

    Rectangle {
        id: bg

        color: Appearance.m3colors.m3paddingContainer
        radius: Config.runtime.bar.modules.radius * Config.runtime.appearance.rounding.factor
        implicitWidth: workspaceRow.implicitWidth + Appearance.margin.large - 8
        implicitHeight: Config.runtime.bar.modules.height

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
                    radius: Appearance.rounding.small
                    color: ColorUtils.mix(Appearance.m3colors.m3tertiary, Appearance.m3colors.m3surfaceContainerLowest)
                    opacity: 0.8
                    x: modelData.start * (26 + workspaceRow.spacing)
                    width: (modelData.end - modelData.start + 1) * 26 + (modelData.end - modelData.start) * workspaceRow.spacing
                }

            }

        }

        Rectangle {
            id: highlight

            property int index: Hyprland.focusedWorkspaceId - 1
            property real itemWidth: 26
            property real spacing: workspaceRow.spacing
            property real targetX: Math.min(index, numWorkspaces - 1) * (itemWidth + spacing) + 7.3
            // Animated endpoints
            property real animatedX1: targetX
            property real animatedX2: targetX

            x: Math.min(animatedX1, animatedX2)
            anchors.verticalCenter: parent.verticalCenter
            width: Math.abs(animatedX2 - animatedX1) + itemWidth - 1
            height: 24
            radius: Appearance.rounding.small
            color: Appearance.m3colors.m3tertiary
            onTargetXChanged: {
                animatedX1 = targetX;
                animatedX2 = targetX;
            }

            Behavior on animatedX1 {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutSine
                }

            }

            Behavior on animatedX2 {
                enabled: Config.runtime.appearance.animations.enabled
                NumberAnimation {
                    duration: 400 / 3 // One side moves faster to create stretch
                    easing.type: Easing.OutSine
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

                    ClippingRectangle {
                        id: iconContainer

                        anchors.centerIn: parent
                        width: 20
                        height: 20
                        color: "transparent"
                        radius: Appearance.rounding.small
                        clip: true

                        IconImage {
                            id: appIcon

                            visible: Config.runtime.bar.modules.workspaces.showAppIcons
                            anchors.fill: parent
                            rotation: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right") ? 270 : 0
                            source: {
                                const win = Hyprland.focusedWindowForWorkspace(index + 1);
                                return win ? Quickshell.iconPath(FileUtils.resolveIcon(win.class)) : "";
                            }
                        }

                    }

                    Tint {
                        rotation: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right") ? 270 : 0
                        sourceItem: appIcon
                    }

                    MaterialSymbol {
                        id: symbol

                        // Compute text based on priority
                        property string displayText: {
                            const square = "crop_square" // Make it square so it won't be inconsistent when rounding factor is 0
                            const circle = "fiber_manual_record"
                            const useSquare = Config.runtime.appearance.rounding.factor === 0

                            if (Config.runtime.bar.modules.workspaces.showAppIcons)
                                return occupied ? "" : (useSquare ? square : circle)

                            if (Config.runtime.bar.modules.workspaces.showJapaneseNumbers)
                                return (occupied || focused)
                                    ? japaneseNumber(index + 1)
                                    : (useSquare ? square : circle)

                            return (occupied || focused)
                                ? "󰮯"
                                : (useSquare ? square : circle)
                        }

                        anchors.centerIn: parent
                        animate: false
                        visible: true
                        rotation: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right") ? 270 : 0
                        text: displayText
                        font.pixelSize: (displayText === "fiber_manual_record" || displayText === "crop_square") ? 10 : (Config.runtime.bar.modules.workspaces.showJapaneseNumbers ? Appearance.font.size.large - 2 : Appearance.font.size.large)
                        fill: (displayText === "fiber_manual_record" || displayText === "crop_square")  ? 1 : 0
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
