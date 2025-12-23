import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.services
import qs.settings
import qs.widgets

ContentMenu {
    title: "Bar"
    description: "Adjust the bar's look."

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

        StyledSwitchOption {
            title: "Enabled"
            description: "Enable or disable the bar."
            prefField: "bar.enabled"
        }

        StyledSwitchOption {
            title: "Floating Bar"
            description: "Whether to keep the bar floating."
            prefField: "bar.floating"
        }

        StyledSwitchOption {
            title: "Goth Corners"
            description: "Enable or disable Goth Corners."
            prefField: "bar.gothCorners"
        }

        StyledSwitchOption {
            title: "Floating Modules"
            description: "Whether to keep the modules floating."
            prefField: "bar.floatingModules"
        }

    }

    ContentCard {
        StyledText {
            text: "Bar Rounding & Size"
            font.pixelSize: 20
            font.bold: true
        }

        NumberStepper {
            label: "Bar Height"
            description: "Adjust the height of the bar."
            prefField: "bar.height"
            minimum: 40
            maximum: 128
        }

        NumberStepper {
            label: "Bar Radius"
            description: "Adjust the radius of the bar."
            prefField: "bar.radius"
            minimum: 10
            maximum: 128
        }

        NumberStepper {
            label: "Module Container Radius"
            description: "Adjust the radius of the module container."
            prefField: "bar.moduleRadius"
            minimum: 10
            maximum: 128
        }

        NumberStepper {
            label: "Island Radius"
            description: "Adjust the radius of the island radius."
            prefField: "bar.islandRadius"
            minimum: 10
            maximum: 128
        }

        StyledText {
            text: "Bar Module Values"
            font.pixelSize: 20
            font.bold: true
        }

        NumberStepper {
            label: "Workspace Indicators"
            description: "Adjust workspaces indicators on the bar."
            prefField: "bar.modules.workspaces.numWorkspaces"
            minimum: 1
            maximum: 10
        }

    }

    ContentCard {
        StyledText {
            text: "Bar Content"
            font.pixelSize: 20
            font.bold: true
        }

        ColumnLayout {
            spacing: 20

            // --- Workspaces ---
            ColumnLayout {
                StyledText {
                    text: "Workspaces"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Workspaces"
                    prefField: "bar.modules.workspaces.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.workspaces.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.workspaces.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['timer_1', 'timer_2']

                            delegate: StyledButton {
                                property string styleValue: modelData

                                icon: modelData
                                implicitWidth: 50
                                checked: {
                                    var val = Shell.flags && Shell.flags.bar && Shell.flags.bar.modules && Shell.flags.bar.modules.workspaces ? Shell.flags.bar.modules.workspaces.largeIcons : false;
                                    return styleValue === 'timer_2' ? !!val : !val;
                                }
                                topLeftRadius: index === 0 ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: index === 0 ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: index === (model.count - 1) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: index === (model.count - 1) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: {
                                    Shell.setNestedValue("bar.modules.workspaces.largeIcons", styleValue === 'timer_2');
                                }
                            }

                        }
                        */

                    }

                }

            }

            // --- System Tray ---
            ColumnLayout {
                StyledText {
                    text: "System Tray"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable System Tray"
                    prefField: "bar.modules.systemTray.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.systemTray.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.systemTray.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.systemTray.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.systemTray.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.systemTray.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.systemTray.style", 2)
                        }
                        */

                    }

                }

            }

            // --- Media ---
            ColumnLayout {
                StyledText {
                    text: "Media"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Media Module"
                    prefField: "bar.modules.media.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.media.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.media.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.media.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.media.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.media.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.media.style", 2)
                        }
                        */

                    }

                }

            }

            // --- Bluetooth & WiFi ---
            ColumnLayout {
                StyledText {
                    text: "Bluetooth & WiFi"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Bluetooth/WiFi Module"
                    prefField: "bar.modules.bluetoothWifi.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.bluetoothWifi.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.bluetoothWifi.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.bluetoothWifi.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.bluetoothWifi.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.bluetoothWifi.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.bluetoothWifi.style", 2)
                        }
                        */

                    }

                }

            }

            // --- Network ---
            ColumnLayout {
                StyledText {
                    text: "Network"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Network Module"
                    prefField: "bar.modules.network.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.network.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.network.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.network.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.network.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.network.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.network.style", 2)
                        }
                        */

                    }

                }

            }

            // --- User Hostname ---
            ColumnLayout {
                StyledText {
                    text: "User Hostname"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable User/Hostname Module"
                    prefField: "bar.modules.userHostname.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.userHostname.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.userHostname.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.userHostname.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.userHostname.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.userHostname.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.userHostname.style", 2)
                        }
                        */

                    }

                }

            }

            // --- Active Top Level ---
            ColumnLayout {
                StyledText {
                    text: "Active Top Level"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Active Top Level Module"
                    prefField: "bar.modules.activeTopLevel.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.activeTopLevel.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.activeTopLevel.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.activeTopLevel.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.activeTopLevel.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.activeTopLevel.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.activeTopLevel.style", 2)
                        }
                        */

                    }

                }

            }

            // --- Clock ---
            ColumnLayout {
                StyledText {
                    text: "Clock"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Clock Module"
                    prefField: "bar.modules.clock.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.clock.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.clock.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.clock.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.clock.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.clock.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.clock.style", 2)
                        }
                        */

                    }

                }

            }

            // --- Launcher Toggle ---
            ColumnLayout {
                StyledText {
                    text: "Launcher Toggle"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Launcher Toggle Module"
                    prefField: "bar.modules.launcherToggle.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.launcherToggle.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.launcherToggle.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.launcherToggle.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.launcherToggle.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.launcherToggle.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.launcherToggle.style", 2)
                        }
                        */

                    }

                }

            }

            // --- Power Menu Toggle ---
            ColumnLayout {
                StyledText {
                    text: "PowerMenu Toggle"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable PowerMenu Toggle Module"
                    prefField: "bar.modules.powerMenuToggle.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.powerMenuToggle.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.powerMenuToggle.position", posValue)
                            }

                        }

                        /*Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        StyledButton {
                            icon: "timer_1"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.powerMenuToggle.style === 1
                            topLeftRadius: Appearance.rounding.normal
                            bottomLeftRadius: Appearance.rounding.normal
                            topRightRadius: Appearance.rounding.small
                            bottomRightRadius: Appearance.rounding.small
                            onClicked: Shell.setNestedValue("bar.modules.powerMenuToggle.style", 1)
                        }

                        StyledButton {
                            icon: "timer_2"
                            font.family: "Material Symbols Rounded"
                            implicitWidth: 50
                            checked: Shell.flags.bar.modules.powerMenuToggle.style === 2
                            topLeftRadius: Appearance.rounding.small
                            bottomLeftRadius: Appearance.rounding.small
                            topRightRadius: Appearance.rounding.normal
                            bottomRightRadius: Appearance.rounding.normal
                            onClicked: Shell.setNestedValue("bar.modules.powerMenuToggle.style", 2)
                        }
                        */

                    }

                }

            }

        }

    }

}
