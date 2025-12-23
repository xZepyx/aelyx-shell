import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.functions
import qs.modules.notifications
import qs.services
import qs.settings
import qs.widgets

StyledRect {
    id: root

    Layout.fillWidth: true
    radius: Appearance.rounding.normal
    color: Appearance.m3colors.m3surfaceContainerHigh

    property bool dndActive: Shell.flags.misc.dndEnabled
    property string themestatusicon: dndActive ? "do_not_disturb_on" : "do_not_disturb_off"

    function toggleDnd() {
        Shell.setNestedValue("misc.dndEnabled", !dndActive);
    }

    StyledButton {
        id: clearButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 10
        anchors.rightMargin: 10
        text: "Clear"
        implicitHeight: 40
        implicitWidth: 80
        secondary: true

        onClicked: {
            for (let i = 0; i < NotifServer.history.length; i++) {
                let n = NotifServer.history[i];
                if (n?.notification) n.notification.dismiss();
            }
        }
    }

    StyledButton {
        id: silentButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 10
        anchors.rightMargin: clearButton.implicitWidth + 15
        text: "Silent"
        implicitHeight: 40
        implicitWidth: 80
        secondary: true
        checkable: true 
        checked: Shell.flags.misc.dndEnabled

        onClicked: {
            toggleDnd()
        }
    }

    StyledText {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 15
        anchors.leftMargin: 15
        text: NotifServer.history.length + " Notifications"

    }

    StyledText {
        anchors.centerIn: parent
        text: "No notifications"
        visible: NotifServer.history.length < 1
        font.pixelSize: Appearance.font.size.huge
    }

    ListView {
        id: notifList
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: clearButton.top
        anchors.margins: 10

        clip: true
        spacing: 8
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar { }

        model: Shell.flags.misc.notificationDaemonEnabled
            ? NotifServer.history
            : []

        delegate: NotificationChild {
            width: notifList.width
            title: model.summary
            body: model.body
            image: model.image || model.appIcon
            rawNotif: model
            buttons: model.actions.map((action) => ({
                "label": action.text,
                "onClick": () => action.invoke()
            }))
        }
    }

}
