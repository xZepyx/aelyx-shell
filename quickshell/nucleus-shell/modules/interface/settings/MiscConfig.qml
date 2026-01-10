import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.widgets
import qs.services

ContentMenu {
    title: "Miscellaneous"
    description: "Configure misc settings."

    ContentCard {
        StyledText {
            text: "Versions"
            font.pixelSize: 20
            font.bold: true
        }

        RowLayout {
            id: releaseChannelSelector
            property string title: "Release Channel"
            property string description: "Choose the release channel for updates."
            property string prefField: ''

            ColumnLayout {
                StyledText { text: releaseChannelSelector.title; font.pixelSize: 16;  }
                StyledText { text: releaseChannelSelector.description; font.pixelSize: 12; }
            }
            Item { Layout.fillWidth: true }

            StyledDropDown {
                label: "Type"
                model: ["Stable", "Edge (indev)"]

                currentIndex: Config.runtime.shell.releaseChannel === "edge" ? 1 : 0

                onSelectedIndexChanged: (index) => {
                    Config.updateKey(
                        "shell.releaseChannel",
                        index === 1 ? "edge" : "stable"
                    )
                    UpdateNotifier.notified = false
                }
            }


        }

    }
}
