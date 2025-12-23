import qs.settings
import qs.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: content
    anchors.fill: parent
    opacity: GlobalStates.launcherOpen ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 400
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animation.curves.standard
        }
    }

    anchors.margins: 20

    property int selectedIndex: -1
    property string searchQuery: ""

    ListModel { id: appModel }
    ListModel { id: filteredModel }

    Process {
        id: appLoader
        command: ["bash", "-c", "bash \"$HOME/.local/share/aelyx/scripts/finders/find-apps.sh\""]
        stdout: SplitParser {
            onRead: data => {
                const lines = data.split("\n")
                for (let i = 0; i < lines.length; ++i) {
                    const line = lines[i].trim()
                    if (!line) continue
                    const parts = line.split("|")
                    if (parts.length >= 4) {
                        const rawName = parts[0].trim()
                        const isCustom = rawName.startsWith("?")
                        const displayName = isCustom ? rawName.slice(1) : rawName  // strip "?" for UI

                        appModel.append({
                            name: rawName,          // keep for logic
                            displayName: displayName, // show this in UI
                            comment: parts[1].trim(), // Why did I started to get custom prefixes :(
                            icon: parts[2].trim(),
                            exec: parts[3].trim(),
                            isCustom: isCustom
                        })
                    }
                }
                content.updateFilter()
            }
        }
    }

    function reloadApps() {
        appModel.clear()
        filteredModel.clear()
        appLoader.running = true
    }

    function updateFilter() {
        filteredModel.clear()
        const query = searchQuery.toLowerCase().trim()
        const customSearch = query.startsWith("?")
        const realQuery = customSearch ? query.slice(1) : query

        for (let i = 0; i < appModel.count; i++) {
            const app = appModel.get(i)

            // Hide custom apps if not using @ prefix
            if (app.isCustom && !customSearch) continue
            // Hide normal apps if using @ prefix
            if (!app.isCustom && customSearch) continue

            if (
                realQuery === "" ||
                (app.name && app.name.toLowerCase().includes(realQuery)) ||
                (app.comment && app.comment.toLowerCase().includes(realQuery))
            ) {
                filteredModel.append(app)
            }
        }

        selectedIndex = filteredModel.count > 0 ? 0 : -1
        listView.currentIndex = selectedIndex
        listView.positionViewAtBeginning()
    }

    function launchApp(idx) {
        if (idx < 0 || idx >= filteredModel.count) return
        const app = filteredModel.get(idx)
        Quickshell.execDetached(["bash", "-c", app.exec + " &"])
        closeLauncher()
    }

    function closeLauncher() {
        GlobalStates.launcherOpen = false
    }

    function resetSearch() {
        searchQuery = ""
        searchField.text = ""
        updateFilter()
        selectedIndex = -1
        listView.currentIndex = -1
    }

    Component.onCompleted: reloadApps()

    onVisibleChanged: {
        if (GlobalStates.launcherOpen) {
            Qt.callLater(() => {
                resetSearch()
                searchField.forceActiveFocus()
            })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        RowLayout {
            width: parent.width
            height: 44
            spacing: 8

            StyledText {
                text: "Applications"
                font.pixelSize: 16
                font.bold: true
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            MaterialSymbol {
                icon: ""
                iconSize: Appearance.font.size.icon.large
                opacity: 0.8

                MouseArea {
                    anchors.fill: parent
                    onClicked: closeLauncher()
                    hoverEnabled: true
                    onEntered: parent.opacity = 1
                    onExited: parent.opacity = 0.8
                }
            }
        }

        Rectangle {
            id: searchBg
            radius: Appearance.rounding.normal
            color: Appearance.m3colors.m3surfaceContainerHighest
            border.color: Appearance.m3colors.m3outlineVariant
            border.width: 0.5
            Layout.fillWidth: true      
            height: 44

            Row {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                MaterialSymbol {
                    icon: ""
                    iconSize: 18
                    Layout.alignment: Qt.AlignVCenter
                    y: 2
                }

                StyledTextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Search applications..."
                    text: searchQuery

                    onTextChanged: {
                        searchQuery = text
                        updateFilter()
                    }

                    font.pixelSize: 15
                    background: null

                    Keys.onDownPressed: {
                        if (filteredModel.count > 0) {
                            listView.currentIndex = Math.min(listView.currentIndex + 1, filteredModel.count - 1)
                            listView.positionViewAtIndex(listView.currentIndex, ListView.Contain)
                        }
                    }
                    Keys.onUpPressed: {
                        if (filteredModel.count > 0) {
                            listView.currentIndex = Math.max(listView.currentIndex - 1, 0)
                            listView.positionViewAtIndex(listView.currentIndex, ListView.Contain)
                        }
                    }
                    Keys.onEnterPressed: launchApp(listView.currentIndex)
                    Keys.onReturnPressed: launchApp(listView.currentIndex)
                    Keys.onEscapePressed: closeLauncher()
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: listView
                model: filteredModel
                spacing: 8
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: 0
                preferredHighlightEnd: height
                highlightMoveDuration: 120
                currentIndex: selectedIndex

                delegate: Rectangle {
                    width: listView.width
                    height: 60
                    radius: Appearance.rounding.normal
                    color: listView.currentIndex === index
                        ? Appearance.m3colors.m3paddingContainer
                        : "transparent"

                    Behavior on color { ColorAnimation { duration: 100 } }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 12

                        Image {
                            width: 32
                            height: 32
                            smooth: true
                            mipmap: true
                            antialiasing: true
                            fillMode: Image.PreserveAspectFit
                            sourceSize.width: 128
                            sourceSize.height: 128
                            source: model.icon && model.icon.startsWith("/")
                                ? model.icon
                                : ""
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: listView.width - 120
                            spacing: 4

                            Text {
                                text: model.displayName
                                font.pixelSize: 14
                                font.bold: true
                                elide: Text.ElideRight
                                color: Appearance.m3colors.m3onSurface
                            }

                            Text {
                                text: model.comment
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                color: Appearance.m3colors.m3onSurfaceVariant
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: launchApp(index)
                        onEntered: listView.currentIndex = index
                    }
                }
            }
        }
    }
}
