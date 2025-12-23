import qs.services
import qs.widgets 
import qs.settings
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Scope {
    IpcHandler {
        target: "settings"
        function open(menu: string) {
            GlobalStates.visible_settingsMenu = true
            if (menu !== "" && settingsWindow !== null) {
                for (var i = 0; i < settingsWindow.menuModel.length; i++) {
                    var item = settingsWindow.menuModel[i]
                    if (!item.header && item.label.toLowerCase() === menu.toLowerCase()) {
                        settingsWindow.selectedIndex = item.page
                        break
                    }
                }
            }
        }
    }

    LazyLoader {
        active: GlobalStates.visible_settingsMenu

        Window {
            id: root
            width: 1280
            height: 720
            visible: true
            title: "Aelyx Settings"
            color: Appearance.m3colors.m3background
            onClosing: GlobalStates.visible_settingsMenu = false

            property int selectedIndex: 0
            property bool sidebarCollapsed: false

            property var menuModel: [
                // header
                { header: true, label: "Customization" },
                { icon: "instant_mix", label: "Quick Settings", page: 0 },
                { icon: "toolbar", label: "Bar", page: 1},
                { icon: "wallpaper", label: "Wallpapers", page: 2},
                { icon: "build", label: "Misc", page: 3},
            ]

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

                    Behavior on width {
                        NumberAnimation {
                            duration: Appearance.animation.durations.normal
                            easing.type: Easing.InOutCubic
                        }
                    }

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
                                Behavior on opacity { NumberAnimation { duration: Appearance.animation.durations.small } }
                            }

                            StyledButton {
                                Layout.preferredHeight: 40
                                Layout.alignment: Qt.AlignHCenter
                                icon: root.sidebarCollapsed ? "chevron_right" : "chevron_left"
                                secondary: true
                                onClicked: root.sidebarCollapsed = !root.sidebarCollapsed
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
                                width: sidebarList.width
                                height: modelData.header ? (root.sidebarCollapsed ? 0 : 30) : 40

                                property bool hovered: mouseArea.containsMouse
                                property bool selected: root.selectedIndex === modelData.page && modelData.page !== -1

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
                                    radius: 20
                                    color: selected
                                           ? Appearance.m3colors.m3primary
                                           : (hovered
                                              ? Appearance.m3colors.m3surfaceContainerHigh
                                              : Appearance.m3colors.m3surfaceContainerLow)

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
                                            Behavior on opacity { NumberAnimation { duration: Appearance.animation.durations.small } }
                                        }
                                    }
                                }

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: modelData.page !== undefined
                                    onClicked: {
                                        root.selectedIndex = modelData.page
                                        settingsStack.currentIndex = modelData.page
                                    }
                                }
                            }
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
                    
                    QuickSettings { }
                    Interface { }
                    Wallpaper { }
                    MiscSettings { }
                }
            }
        }
    }

    property var settingsWindow: null
}
