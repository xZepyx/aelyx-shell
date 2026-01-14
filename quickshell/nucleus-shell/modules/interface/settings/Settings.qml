import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.functions
import qs.modules.widgets
import qs.services

Scope {
    property var settingsWindow: null

    IpcHandler {
        function open(menu: string) {
            Globals.states.settingsOpen = true;
            if (menu !== "" && settingsWindow !== null) {
                for (var i = 0; i < settingsWindow.menuModel.length; i++) {
                    var item = settingsWindow.menuModel[i];
                    if (!item.header && item.label.toLowerCase() === menu.toLowerCase()) {
                        settingsWindow.selectedIndex = item.page;
                        break;
                    }
                }
            }
        }

        target: "settings"
    }

    LazyLoader {
        active: Globals.states.settingsOpen

        Window {
            // header

            id: root

            property int selectedIndex: 0
            property bool sidebarCollapsed: false
            property var menuModel: [{
                "header": true,
                "label": "System"
            }, {
                "icon": "bluetooth",
                "label": "Bluetooth",
                "page": 0
            }, {
                "icon": "network_wifi",
                "label": "Network",
                "page": 1
            }, {
                "icon": "volume_up",
                "label": "Audio",
                "page": 2
            }, {
                "icon": "instant_mix",
                "label": "Appearance",
                "page": 3
            }, {
                "header": true,
                "label": "Customization"
            }, {
                "icon": "toolbar",
                "label": "Bar",
                "page": 4
            }, {
                "icon": "wallpaper",
                "label": "Wallpapers",
                "page": 5
            }, {
                "icon": "apps",
                "label": "Launcher",
                "page": 6
            }, {
                "icon": "chat",
                "label": "Notifications",
                "page": 7
            }, {
                "icon": "build",
                "label": "Miscellaneous",
                "page": 8
            }, {
                "header": true,
                "label": "About"
            }, {
                "icon": "info",
                "label": "About",
                "page": 9
            }]

            width: 1280
            height: 720
            visible: true
            title: "Nucleus - Settings"
            color: Appearance.m3colors.m3background
            onClosing: Globals.states.settingsOpen = false
            Component.onCompleted: settingsWindow = root

            Item {
                anchors.fill: parent

                Rectangle {
                    id: sidebarBG

                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: root.sidebarCollapsed ? 80 : 350
                    color: Appearance.m3colors.m3surfaceContainerLow

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.leftMargin: root.sidebarCollapsed ? 10 : 40
                        anchors.rightMargin: root.sidebarCollapsed ? 10 : 40
                        anchors.topMargin: 40
                        anchors.bottomMargin: 40
                        spacing: 5

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 10

                            StyledText {
                                Layout.fillWidth: true
                                text: "Settings"
                                color: Appearance.m3colors.m3onSurface
                                font.family: "Outfit ExtraBold"
                                font.pixelSize: 28
                                visible: !root.sidebarCollapsed
                                opacity: root.sidebarCollapsed ? 0 : 1

                                Behavior on opacity {
                                    enabled: Config.runtime.appearance.animations.enabled
                                    NumberAnimation {
                                        duration: Appearance.animation.durations.small
                                    }

                                }

                            }

                            StyledButton {
                                Layout.preferredHeight: 40
                                Layout.alignment: Qt.AlignHCenter
                                icon: root.sidebarCollapsed ? "chevron_right" : "chevron_left"
                                secondary: true
                                onClicked: root.sidebarCollapsed = !root.sidebarCollapsed
                            }

                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 48
                            Layout.bottomMargin: 15
                            Layout.topMargin: 15

                            ContentCard {
                                id: userCard

                                cardMargin: 8
                                useAnims: false
                                cardSpacing: 0
                                verticalPadding: 16
                                visible: !root.sidebarCollapsed
                                opacity: root.sidebarCollapsed ? 0 : 1
                                color: Appearance.m3colors.m3surfaceContainer

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 8

                                        ClippingRectangle {
                                            radius: Appearance.rounding.childish * 2
                                            color: "transparent"
                                            Layout.preferredWidth: 36
                                            Layout.preferredHeight: 42

                                            IconImage {
                                                anchors.fill: parent
                                                source: Config.runtime.misc.pfp
                                            }

                                        }

                                        StyledText {
                                            text: Quickshell.env("USER")
                                            font.pixelSize: 19
                                            font.family: "Outfit SemiBold"
                                        }

                                    }

                                }

                            }

                        }

                        ListView {
                            id: sidebarList

                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: root.menuModel
                            spacing: 5
                            boundsBehavior: Flickable.StopAtBounds

                            delegate: Item {
                                property bool hovered: mouseArea.containsMouse
                                property bool selected: root.selectedIndex === modelData.page && modelData.page !== -1

                                width: sidebarList.width
                                height: modelData.header ? (root.sidebarCollapsed ? 0 : 30) : 40
                                visible: !modelData.header || !root.sidebarCollapsed

                                // header
                                Item {
                                    width: parent.width
                                    height: parent.height

                                    StyledText {
                                        y: (parent.height - height) * 0.5
                                        x: 10
                                        text: modelData.label
                                        font.pixelSize: 14
                                        font.bold: true
                                    }

                                }

                                // sidebar button
                                Rectangle {
                                    anchors.fill: parent
                                    visible: !modelData.header
                                    radius: Appearance.rounding.large
                                    color: selected ? Appearance.m3colors.m3primary : (hovered ? Appearance.m3colors.m3surfaceContainerHigh : Appearance.m3colors.m3surfaceContainerLow)

                                    RowLayout {
                                        y: (parent.height - height) * 0.5
                                        x: root.sidebarCollapsed ? (parent.width - width) * 0.5 : 10
                                        spacing: 10

                                        MaterialSymbol {
                                            visible: !modelData.header
                                            icon: modelData.icon ? modelData.icon : ""
                                            color: selected ? Appearance.m3colors.m3onPrimary : Appearance.m3colors.m3onSurface
                                            iconSize: 24
                                        }

                                        StyledText {
                                            text: modelData.label
                                            font.pixelSize: 16
                                            color: selected ? Appearance.m3colors.m3onPrimary : Appearance.m3colors.m3onSurface
                                            visible: !root.sidebarCollapsed
                                            opacity: root.sidebarCollapsed ? 0 : 1

                                            Behavior on opacity {
                                                enabled: Config.runtime.appearance.animations.enabled
                                                NumberAnimation {
                                                    duration: Appearance.animation.durations.small
                                                }

                                            }

                                        }

                                    }

                                }

                                MouseArea {
                                    id: mouseArea

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: modelData.page !== undefined
                                    onClicked: {
                                        root.selectedIndex = modelData.page;
                                        settingsStack.currentIndex = modelData.page;
                                    }
                                }

                            }

                        }

                    }

                    Behavior on width {
                        enabled: Config.runtime.appearance.animations.enabled
                        NumberAnimation {
                            duration: Appearance.animation.durations.normal
                            easing.type: Easing.InOutCubic
                        }

                    }

                }

                StackLayout {
                    id: settingsStack

                    anchors.left: sidebarBG.right
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    currentIndex: root.selectedIndex

                    BluetoothConfig {
                    }

                    NetworkConfig {
                    }

                    AudioConfig {
                    }

                    AppearanceConfig {
                    }

                    BarConfig {
                    }

                    WallpaperConfig {
                    }

                    LauncherConfig {
                    }

                    NotificationConfig {
                    }

                    MiscConfig {
                    }

                    About {
                    }

                }

            }

        }

    }

}
