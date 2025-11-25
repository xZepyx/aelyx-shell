import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.services
import qs.settings
import qs.widgets

ContentMenu {
    title: "Quick Settings"
    description: "Adjust how the desktop looks like quickly."

    ContentCard {
        // ---------- Dark Mode Row ----------
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            ColumnLayout {
                StyledText {
                    text: "Dark mode"
                    font.pixelSize: 16
                }

                StyledText {
                    text: "Whether to use dark color schemes."
                    font.pixelSize: 12
                }

            }

            Item {
                Layout.fillWidth: true
            }

            StyledSwitch {
                checked: Shell.flags.appearance.theme === "dark"
                onToggled: {
                    Quickshell.execDetached({
                        "command": ['qs', 'ipc', 'call', 'global', "toggleTheme"]
                    });
                }
            }

        }

        ColumnLayout {
            StyledText {
                text: "Color Generation Schemes:"
                font.pixelSize: 16
            }

            GridLayout {
                rows: 2
                columns: 4

                Repeater {
                    model: ["scheme-content", "scheme-expressive", "scheme-fidelity", "scheme-fruit-salad", "scheme-monochrome", "scheme-neutral", "scheme-rainbow", "scheme-tonal-spot"]

                    delegate: StyledButton {
                        text: modelData
                        clip: true
                        Layout.fillWidth: true
                        implicitWidth: 0
                        // Selected state
                        checked: Shell.flags.appearance.colorScheme === modelData
                        // Rounded corners depending on whether this is first/last item
                        topLeftRadius: index === 0 ? Appearance.rounding.normal : Appearance.rounding.small
                        bottomLeftRadius: index === 0 ? Appearance.rounding.normal : Appearance.rounding.small
                        topRightRadius: index === (model.count - 1) ? Appearance.rounding.normal : Appearance.rounding.small
                        bottomRightRadius: index === (model.count - 1) ? Appearance.rounding.normal : Appearance.rounding.small
                        onClicked: {
                            Shell.setNestedValue("appearance.colorScheme", modelData);
                            Quickshell.execDetached(["qs", "ipc", "call", "global", "regenColors"]);
                        }
                    }

                }

            }

        }

    }

    ContentCard {
        StyledText {
            text: "Bar"
            font.pixelSize: 20
            font.bold: true
        }

        ColumnLayout {
            StyledText {
                text: "Position"
                font.pixelSize: 16
            }

            RowLayout {
                spacing: 8

                Repeater {
                    model: ['Top', 'Bottom']

                    delegate: StyledButton {
                        property bool isTop: modelData.toLowerCase() === "top"

                        text: modelData
                        implicitWidth: 0
                        Layout.fillWidth: true // make both buttons full width
                        checked: Shell.flags.bar.atTop === isTop
                        // Rounded corners for visual consistency
                        topLeftRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        bottomLeftRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        topRightRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        bottomRightRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        onClicked: Shell.setNestedValue("bar.atTop", isTop)
                    }

                }

            }

        }

        ColumnLayout {
            StyledText {
                text: "Density"
                font.pixelSize: 16
            }

            RowLayout {
                spacing: 8

                StyledButton {
                    text: "Cozy"
                    implicitWidth: 0
                    Layout.fillWidth: true
                    checked: Shell.flags.bar.height === 60
                    onClicked: Shell.setNestedValue("bar.height", 60)
                }

                StyledButton {
                    text: "Comfortable"
                    implicitWidth: 0
                    Layout.fillWidth: true
                    checked: Shell.flags.bar.height === 50
                    onClicked: Shell.setNestedValue("bar.height", 50)
                }

                StyledButton {
                    text: "Cocky"
                    implicitWidth: 0
                    Layout.fillWidth: true
                    checked: Shell.flags.bar.height === 45
                    onClicked: Shell.setNestedValue("bar.height", 45)
                }

                StyledButton {
                    text: "Condensed"
                    implicitWidth: 0
                    Layout.fillWidth: true
                    checked: Shell.flags.bar.height <= 40
                    onClicked: Shell.setNestedValue("bar.height", 40)
                }

            }

        }

        StyledSwitchOption {
            title: "Enabled"
            description: "Enable of disable the bar."
            prefField: "bar.enabled"
        }

        StyledSwitchOption {
            title: "Floating Bar"
            description: "Whether to keep the bar floating."
            prefField: "bar.floating"
        }

        StyledSwitchOption {
            title: "Floating Modules"
            description: "Whether to keep the modules floating."
            prefField: "bar.floatingModules"
        }

    }

    ContentCard {
        StyledText {
            text: "Clock"
            font.pixelSize: 20
            font.bold: true
        }

        StyledSwitchOption {
            title: "Show Clock"
            description: "Whether to show or disable the clock on the background."
            prefField: "background.showClock"
        }

        NumberStepper {
            label: "X Offset"
            description: "Change the X offset of the clock."
            prefField: "background.clockX"
            minimum: 1
            maximum: 128
        }

        NumberStepper {
            label: "Y Offset"
            description: "Change the Y offset of the clock."
            prefField: "background.clockY"
            minimum: 1
            maximum: 128
        }

    }

}
