import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell.Wayland
import qs.config
import qs.modules.widgets
import qs.services
import qs.modules.functions

Rectangle {
    id: root

    required property LockContext context

    color: "transparent"

    Image {
        anchors.fill: parent 
        z: -1
        source: Config.runtime.appearance.background.path 
    }

    RowLayout {
        spacing: 20

        anchors {
            top: parent.top
            right: parent.right
            topMargin: 20
            rightMargin: 30
        }

        MaterialSymbol {
            id: themeIcon

            visible: Config.runtime.bar.modules.statusIcons.themeStatusEnabled
            fill: 1
            icon: Config.runtime.appearance.theme === "light" ? "light_mode" : "dark_mode"
            iconSize: Appearance.font.size.hugeass
        }

        MaterialSymbol {
            id: wifi

            visible: Config.runtime.bar.modules.statusIcons.networkStatusEnabled
            icon: Network.icon
            iconSize: Appearance.font.size.hugeass
        }

        MaterialSymbol {
            id: btIcon

            visible: Config.runtime.bar.modules.statusIcons.bluetoothStatusEnabled
            icon: Bluetooth.icon
            iconSize: Appearance.font.size.hugeass
        }

        StyledText {
            id: keyboardLayoutIcon

            visible: Config.runtime.bar.modules.statusIcons.keyboardLayoutStatusEnabled
            text: SystemDetails.keyboardLayout
            font.pixelSize: Appearance.font.size.huge - 4
        }

    }

    ColumnLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 150
        }

        spacing: 0

        StyledText {
            id: clock
            Layout.alignment: Qt.AlignBottom
            animate: false
            renderType: Text.NativeRendering
            font.pixelSize: 180
            text: Time.format("hh:mm")
        }

        StyledText {
            id: date
            Layout.alignment: Qt.AlignCenter
            animate: false
            renderType: Text.NativeRendering
            font.pixelSize: 50
            text: Time.format("dddd, dd/MM")
        }

    }

    ColumnLayout {
        // Uncommenting this will make the password entry invisible except on the active monitor.
        // visible: Window.active

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }

        RowLayout {
            StyledTextField {
                id: passwordBox
                implicitWidth: 300
                padding: 10
                placeholder: root.context.showFailure ? "Incorrect Password" : "Enter Password"
                focus: true
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                // Update the text in the context when the text in the box changes.
                onTextChanged: root.context.currentText = this.text
                // Try to unlock when enter is pressed.
                onAccepted: root.context.tryUnlock()

                // Update the text in the box to match the text in the context.
                // This makes sure multiple monitors have the same text.
                Connections {
                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText;
                    }

                    target: root.context
                }

            }

            StyledButton {
                icon: "chevron_right"
                padding: 10
                radius: 6
                // don't steal focus from the text box
                focusPolicy: Qt.NoFocus
                enabled: !root.context.unlockInProgress && root.context.currentText !== ""
                onClicked: root.context.tryUnlock()
            }

        }

    }

}
