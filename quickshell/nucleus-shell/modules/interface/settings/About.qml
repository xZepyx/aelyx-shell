import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Quickshell
import Quickshell.Widgets
import qs.modules.widgets 
import qs.config 
import qs.services

Item {

    ColumnLayout {
        anchors.centerIn: parent

        ColumnLayout {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter


            ColumnLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                StyledText {
                    text: SystemDetails.osIcon
                    font.pixelSize: 280
                    horizontalAlignment: Text.AlignHCenter
                }

                StyledText {
                    text: "Nucleus Shell"
                    font.pixelSize: 24
                    font.family: "Outfit ExtraBold"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: 400
                }

                StyledText {
                    text: "A Shell built to get things done."
                    font.pixelSize: 14
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: 400
                }
            }
            Item {}
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                StyledButton {
                    text: "View on GitHub"
                    icon: 'code'
                    secondary: true
                    onClicked: Qt.openUrlExternally("https://github.com/xZepyx/nucleus-shell")
                    topRightRadius: 5
                    bottomRightRadius: 5
                }
                StyledButton {
                    text: "Report Issue"
                    icon: "bug_report"
                    secondary: true
                    onClicked: Qt.openUrlExternally("https://github.com/xZepyx/nucleus-shell/issues")
                    topLeftRadius: 5
                    bottomLeftRadius: 5
                }

            }
        }
    }

    StyledRect {
        color: ma.containsMouse ? Qt.lighter(Appearance.m3colors.m3secondaryContainer, 1.1) : Appearance.m3colors.m3secondaryContainer
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 40
        implicitHeight: updateText.height + 20
        implicitWidth: implicitHeight
        radius: 10
        StyledText {
            id: updateText
            text: "󰚰" // These come in handy sometimes
            font.pixelSize: 24
            anchors.centerIn: parent
        }
        MouseArea {
            id: ma
            anchors.fill: parent 
            hoverEnabled: true
            onClicked: {
                Globals.states.settingsOpen = false;
                Quickshell.execDetached(["notify-send", "Updating Nucleus Shell"])
                Quickshell.execDetached(["kitty", "--hold" ,"bash", "-c", Directories.scriptsPath + "/system/update.sh"])
            }
        }
    }
    StyledText {
        text: "Nucleus-Shell v" + Config.runtime.shell.version
        font.pixelSize: 12
        textFormat: Text.RichText
        horizontalAlignment: Text.AlignHCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        onLinkActivated: Qt.openUrlExternally(link)
    }
}