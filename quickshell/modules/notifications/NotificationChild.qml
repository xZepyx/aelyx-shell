import qs.settings 
import qs.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

Rectangle {
    id: root
    property bool startAnim: false

    property string title: "WawaApp"
    property string body: "No content"
    property var rawNotif: null
    property bool tracked: false
    property string image: ""
    property var buttons: [
        { label: "Okay!", onClick: () => console.log("Okay") }
    ]

    opacity: tracked ? 1 : (startAnim ? 1 : 0)
    Behavior on opacity {
        NumberAnimation {
            duration: Appearance.animation.durations.small
            easing.type: Easing.InOutExpo
        }
    }

    Layout.fillWidth: true
    radius: 20

    property bool hovered: mouseHandler.containsMouse
    property bool clicked: mouseHandler.containsPress
    color: hovered ? (clicked ? Appearance.m3colors.m3surfaceContainerHigh : Appearance.m3colors.m3surfaceContainerLow) : Appearance.m3colors.m3surface
    Behavior on color {
        ColorAnimation {
            duration: Appearance.animation.durations.small
            easing.type: Easing.InOutExpo
        }
    }
    implicitHeight: Math.max(content.implicitHeight + 30, 80)

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        ClippingRectangle {
            width: 50
            height: 50
            radius: 20
            clip: true
            color: root.image === "" ? Appearance.m3colors.m3surfaceContainer : "transparent"
            Image {
                anchors.fill: parent
                source: root.image
                fillMode: Image.PreserveAspectCrop
                smooth: true
            }
            MaterialSymbol {
                icon: "terminal"
                color: Appearance.m3colors.m3onSurfaceVariant
                anchors.centerIn: parent
                visible: root.image === ""
                iconSize: 32
            }
        }

        ColumnLayout {
            StyledText {
                text: root.title
                font.bold: true
                font.pixelSize: 18
                wrapMode: Text.Wrap
                color: Appearance.m3colors.m3onSurface
                Layout.fillWidth: true
            }

            StyledText {
                text: root.body.length > 123 ? root.body.substr(0, 120) + "..." : root.body
                visible: root.body.length > 0
                font.pixelSize: 12
                color: Appearance.m3colors.m3onSurfaceVariant
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            RowLayout {
                visible: root.buttons.length > 1
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                spacing: 10

                Repeater {
                    model: buttons

                    StyledButton {
                        Layout.fillWidth: true
                        implicitHeight: 30
                        implicitWidth: 0
                        text: modelData.label
                        base_bg: index !== 0
                            ? Appearance.m3colors.m3secondaryContainer
                            : Appearance.m3colors.m3primary

                        base_fg: index !== 0
                            ? Appearance.m3colors.m3onSecondaryContainer
                            : Appearance.m3colors.m3onPrimary
                        onClicked: modelData.onClick()
                    }
                }
            }
        }
    }
    MouseArea {
        id: mouseHandler
        anchors.fill: parent
        hoverEnabled: true
        visible: root.buttons.length === 0 || root.buttons.length === 1
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.buttons.length === 1 && root.buttons[0].onClick) {
                root.buttons[0].onClick()
                root.rawNotif?.notification.dismiss()
            } else if (root.buttons.length === 0) {
                console.log("[Notification] Dismissed a notification with no action.")
                root.rawNotif.notification.tracked = false
                root.rawNotif.popup = false
                root.rawNotif?.notification.dismiss()
            } else {
                console.log("[Notification] Dismissed a notification with multiple actions.")
                root.rawNotif?.notification.dismiss()
            }
        }
    }
    Component.onCompleted: {
        startAnim = true
    }
}