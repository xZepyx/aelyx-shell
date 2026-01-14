import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.modules.widgets

Scope {
    id: root

    GothCorners {
        opacity: Config.runtime.bar.gothCorners && !Config.runtime.bar.floating && Config.runtime.bar.enabled && !Config.runtime.bar.merged ? 1 : 0
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            // some exclusiveSpacing so it won't look like its sticking into the window when floating

            id: bar

            required property var modelData
            property int rd: Config.runtime.bar.radius * Config.runtime.appearance.rounding.factor // So it won't be modified when factor is 0
            property int margin: Config.runtime.bar.margins
            property bool floating: Config.runtime.bar.floating
            property bool merged: Config.runtime.bar.merged
            property string pos: Config.runtime.bar.position
            property bool vertical: pos === "left" || pos === "right"
            // Simple position properties
            property bool attachedTop: pos === "top"
            property bool attachedBottom: pos === "bottom"
            property bool attachedLeft: pos === "left"
            property bool attachedRight: pos === "right"

            screen: modelData // Show bar on all screens
            visible: Config.runtime.bar.enabled && Config.initialized
            WlrLayershell.namespace: "nucleus:bar"
            exclusiveZone: Config.runtime.bar.floating ? Config.runtime.bar.density + Appearance.margin.tiny : Config.runtime.bar.density
            implicitHeight: Config.runtime.bar.density // density === height. (horizontal orientation)
            implicitWidth: Config.runtime.bar.density // density === width. (vertical orientation)
            color: "transparent" // Keep panel window's color transparent, so that it can be modified by background rect

            // This is probably a little weird way to set anchors but I think it's the best way. (and it works)
            anchors {
                top: Config.runtime.bar.position === "top" || Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right"
                bottom: Config.runtime.bar.position === "bottom" || Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right"
                left: Config.runtime.bar.position === "left" || Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom"
                right: Config.runtime.bar.position === "right" || Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom"
            }

            margins {
                top: {
                    if (floating)
                        return margin;

                    if (merged && vertical)
                        return margin;

                    return 0;
                }
                bottom: {
                    if (floating)
                        return margin;

                    if (merged && vertical)
                        return margin;

                    return 0;
                }
                left: {
                    if (floating)
                        return margin;

                    if (merged && !vertical)
                        return margin;

                    return 0;
                }
                right: {
                    if (floating)
                        return margin;

                    if (merged && !vertical)
                        return margin;

                    return 0;
                }
            }

            StyledRect {
                id: background

                color: Appearance.m3colors.m3background
                anchors.fill: parent
                topLeftRadius: {
                    if (floating)
                        return rd;

                    if (!merged)
                        return 0;

                    return attachedBottom || attachedRight ? rd : 0;
                }
                topRightRadius: {
                    if (floating)
                        return rd;

                    if (!merged)
                        return 0;

                    return attachedBottom || attachedLeft ? rd : 0;
                }
                bottomLeftRadius: {
                    if (floating)
                        return rd;

                    if (!merged)
                        return 0;

                    return attachedTop || attachedRight ? rd : 0;
                }
                bottomRightRadius: {
                    if (floating)
                        return rd;

                    if (!merged)
                        return 0;

                    return attachedTop || attachedLeft ? rd : 0;
                }

                BarContent {
                    anchors.fill: parent
                }

                Behavior on bottomLeftRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on topLeftRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on bottomRightRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on topRightRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

            }

        }

    }

}
