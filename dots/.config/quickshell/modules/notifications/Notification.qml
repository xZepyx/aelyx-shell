import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell.Wayland
import qs.widgets 
import qs.services
import qs.config

Scope {
    id: root
    property int innerSpacing: 10

    PanelWindow {
        id: window
        implicitWidth: 540 + 20
        visible: true
        anchors{
            top: true
            bottom: true
        }
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusionMode: ExclusionMode.Normal

        mask: Region {
            width: window.width
            height: {
                var total = 0
                for (let i = 0; i < rep.count; i++) {
                    var child = rep.itemAt(i)
                    if (child) {
                        total += child.height + (i < rep.count - 1 ? root.innerSpacing : 0)
                    }
                }
                return total
            }
        }

        Item {
            id: notificationList
            anchors.leftMargin: 20
            anchors.topMargin: 10
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            Rectangle {
                id: bgRectangle
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowOpacity: 1
                    shadowColor: Appearance.m3colors.m3shadow
                    shadowBlur: 1
                    shadowScale: 1
                }
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.right: parent.right
                height: window.mask.height > 0 ? window.mask.height + 40 : 0
                color: Appearance.m3colors.m3background
                radius: 20
                Behavior on height {
                    NumberAnimation {
                        duration: Appearance.animation.durations.small
                        easing.type: Easing.InOutExpo
                    }
                }
            }

            Repeater {
                id: rep
                model: Config.options.misc.notificationDaemonEnabled ? NotifServer.popups : []

                NotificationChild {
                    id: child
                    width: bgRectangle.width - 40
                    x: 40

                    y: {
                        var pos = 0
                        for (let i = 0; i < index; i++) {
                            var prev = rep.itemAt(i)
                            if (prev)
                                pos += prev.height + root.innerSpacing
                        }
                        return pos - (tracked ? 0 : 20) + 20
                    }

                    Component.onCompleted: {
                        if (!modelData.shown)
                            modelData.shown = true
                        y += tracked ? 0 : 20
                    }

                    Behavior on y {
                        NumberAnimation {
                            duration: Appearance.animation.durations.normal
                            easing.type: Easing.InOutExpo
                        }
                    }

                    title: modelData.summary
                    body: modelData.body
                    image: modelData.image || modelData.appIcon
                    rawNotif: modelData

                    tracked: modelData.shown

                    buttons: modelData.actions.map(action => ({
                        label: action.text,
                        onClick: () => {
                            action.invoke()
                        }
                    }))
                }
            }

        }

    }
}