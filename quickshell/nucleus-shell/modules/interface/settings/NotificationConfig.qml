import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.widgets
import qs.services

ContentMenu {
    title: "Notifications & Overlays"
    description: "Adjust notification and overlay settings."

    ContentCard {
        StyledText {
            text: "Notifications"
            font.pixelSize: 20
            font.bold: true
        }

        StyledSwitchOption {
            title: "Enabled"
            description: "Enable or disable built-in notification daemon."
            prefField: "notifications.enabled"
        }

        StyledSwitchOption {
            title: "Do not disturb enabled"
            description: "Enable or disable dnd."
            prefField: "notifications.doNotDisturb"
        }

        RowLayout {
            id: notificationPosSelector

            property string title: "Notification's Position"
            property string description: "Select where notification will be shown."
            property string prefField: ''

            ColumnLayout {
                StyledText {
                    text: notificationPosSelector.title
                    font.pixelSize: 16
                }

                StyledText {
                    text: notificationPosSelector.description
                    font.pixelSize: 12
                }

            }

            Item {
                Layout.fillWidth: true
            }

            StyledDropDown {
                label: "Position"
                model: ["Top Left", "Top Right", "Top"]
                // Set initial index based on Config value
                currentIndex: {
                    switch (Config.runtime.notifications.position.toLowerCase()) {
                    case "top-left":
                        return 0;
                    case "top-right":
                        return 1;
                    case "top":
                        return 2;
                    default:
                        return 0;
                    }
                }
                onSelectedIndexChanged: (index) => {
                    Config.updateKey("notifications.position", model[index].toLowerCase().replace(" ", "-"));
                }
            }

        }

        RowLayout {
            id: testNotif

            property string title: "Test Notifications"
            property string description: "Run a test notification."
            property string prefField: ''

            ColumnLayout {
                StyledText {
                    text: testNotif.title
                    font.pixelSize: 16
                }

                StyledText {
                    text: testNotif.description
                    font.pixelSize: 12
                }

            }

            Item {
                Layout.fillWidth: true
            }

            StyledButton {
                text: "Test Notifications"
                icon: "chat"
                onClicked: Quickshell.execDetached(["notify-send", "This is a test notification"])
            }

        }

    }

    ContentCard {
        StyledText {
            text: "Overlays/OSDs"
            font.pixelSize: 20
            font.bold: true
        }

        StyledSwitchOption {
            title: "Enabled"
            description: "Enable or disable built-in osd(s) daemon."
            prefField: "overlays.enabled"
        }

        StyledSwitchOption {
            title: "Volume Osd enabled"
            description: "Enable or disable volume osd."
            prefField: "overlays.volumeOverlayEnabled"
        }

        StyledSwitchOption {
            title: "Brightness Osd enabled"
            description: "Enable or disable brightness osd."
            prefField: "overlays.brightnessOverlayEnabled"
        }

        RowLayout {
            id: brightnessPosSelector

            property string title: "Brightness Osd Position"
            property string description: "Choose the position where the brightness osd is shown."
            property string prefField: ''

            ColumnLayout {
                StyledText {
                    text: brightnessPosSelector.title
                    font.pixelSize: 16
                }

                StyledText {
                    text: brightnessPosSelector.description
                    font.pixelSize: 12
                }

            }

            Item {
                Layout.fillWidth: true
            }

            StyledDropDown {
                label: "Brightness Overlay Position"
                model: ["Top Left", "Top Right", "Bottom Left", "Bottom Right", "Top", "Bottom"]
                // Set initial index based on Config value
                currentIndex: {
                    switch (Config.runtime.overlays.brightnessOverlayPosition.toLowerCase()) {
                    case "top-left":
                        return 0;
                    case "top-right":
                        return 1;
                    case "bottom-left":
                        return 2;
                    case "bottom-right":
                        return 3;
                    case "top":
                        return 4;
                    case "bottom":
                        return 5;
                    default:
                        return 0;
                    }
                }
                onSelectedIndexChanged: (index) => {
                    Config.updateKey("overlays.brightnessOverlayPosition", model[index].toLowerCase().replace(" ", "-"));
                }
            }

        }

        RowLayout {
            id: volumePosSelector

            property string title: "Volume Osd Position"
            property string description: "Choose the position where the volume osd is shown."
            property string prefField: ''

            ColumnLayout {
                StyledText {
                    text: volumePosSelector.title
                    font.pixelSize: 16
                }

                StyledText {
                    text: volumePosSelector.description
                    font.pixelSize: 12
                }

            }

            Item {
                Layout.fillWidth: true
            }

            StyledDropDown {
                label: "Volume Overlay Position"
                model: ["Top Left", "Top Right", "Bottom Left", "Bottom Right", "Top", "Bottom"]
                // Set initial index based on Config value
                currentIndex: {
                    switch (Config.runtime.overlays.volumeOverlayPosition.toLowerCase()) {
                    case "top-left":
                        return 0;
                    case "top-right":
                        return 1;
                    case "bottom-left":
                        return 2;
                    case "bottom-right":
                        return 3;
                    case "top":
                        return 4;
                    case "bottom":
                        return 5;
                    default:
                        return 0;
                    }
                }
                onSelectedIndexChanged: (index) => {
                    Config.updateKey("overlays.volumeOverlayPosition", model[index].toLowerCase().replace(" ", "-"));
                }
            }

        }

    }

}
