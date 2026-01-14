import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.config
import qs.modules.functions
import qs.modules.widgets
import qs.services

Item {
    // Root item for the launcher
    // Handles searching, launching apps, web search, and calculations, basiclly all the stuff in the launcher

    id: content

    // Index of the currently selected app in the filtered list
    property int selectedIndex: -1
    // Current search query typed by the user
    property string searchQuery: ""
    // Variables used for calculations
    property var calcVars: ({
    })
    // Expose the ListView and filtered model to other components if needed
    property alias listView: listView
    property alias filteredModel: filteredModel

    // Launch the currently selected item
    function launchCurrent() {
        launchApp(listView.currentIndex);
    }

    // Build URL for web search based on user's configured search engine
    function webSearchUrl(query) {
        const engine = (Config.runtime.launcher.webSearchEngine || "").toLowerCase();
        if (engine.startsWith("http"))
            return engine.replace("%s", encodeURIComponent(query));

        const engines = {
            "google": "https://www.google.com/search?q=%s",
            "duckduckgo": "https://duckduckgo.com/?q=%s",
            "brave": "https://search.brave.com/search?q=%s",
            "bing": "https://www.bing.com/search?q=%s",
            "startpage": "https://www.startpage.com/search?q=%s"
        };
        const template = engines[engine] || engines["duckduckgo"];
        return template.replace("%s", encodeURIComponent(query));
    }

    // Move selection up/down in the filtered list
    function moveSelection(delta) {
        if (filteredModel.count === 0)
            return ;

        selectedIndex = Math.max(0, Math.min(selectedIndex + delta, filteredModel.count - 1));
        listView.currentIndex = selectedIndex;
        listView.positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    // Reload all apps (re-run the app finder script)
    function reloadApps() {
        appModel.clear();
        filteredModel.clear();
        appLoader.running = true;
    }

    // Simple fuzzy search helper
    function fuzzyMatch(text, pattern) {
        text = text.toLowerCase();
        pattern = pattern.toLowerCase();
        let ti = 0, pi = 0;
        while (ti < text.length && pi < pattern.length) {
            if (text[ti] === pattern[pi])
                pi++;

            ti++;
        }
        return pi === pattern.length;
    }

    // Evaluate math expressions in search (e.g., "2+2")
    function evalExpression(expr) {
        try {
            const fn = new Function("vars", `
                with (vars) {
                    with (Math) {
                        return (${expr});
                    }
                }
            `);
            const res = fn(calcVars);
            if (res === undefined || Number.isNaN(res))
                return null;

            return res;
        } catch (e) {
            return null;
        }
    }

    // Filter apps and calculations based on current query
    function updateFilter() {
        filteredModel.clear();
        const query = searchQuery.toLowerCase().trim();
        // Check if the query is a calculation
        const calcVal = evalExpression(query);
        if (calcVal !== null && query !== "")
            filteredModel.append({
            "name": String(calcVal),
            "displayName": String(calcVal),
            "comment": "Calculation",
            "icon": "",
            "exec": "",
            "isCalc": true,
            "isWeb": false
        });

        // Filter apps from appModel
        for (let i = 0; i < appModel.count; i++) {
            const app = appModel.get(i);
            let match = false;
            if (query === "") {
                match = true; // Show all if empty query
            } else if (Config.runtime.launcher.fuzzySearchEnabled) {
                if ((app.name && fuzzyMatch(app.name, query)) || (app.comment && fuzzyMatch(app.comment, query)))
                    match = true;

            } else {
                if ((app.name && app.name.toLowerCase().includes(query)) || (app.comment && app.comment.toLowerCase().includes(query)))
                    match = true;

            }
            if (match)
                filteredModel.append(app);

        }
        // If nothing matched, offer a web search
        if (filteredModel.count === 0 && query !== "")
            filteredModel.append({
                "name": query,
                "displayName": "Search the web for \"" + query + "\"",
                "comment": "Web search",
                "icon": "public",
                "exec": webSearchUrl(query),
                "isCalc": false,
                "isWeb": true
            });

        // Update selection
        selectedIndex = filteredModel.count > 0 ? 0 : -1;
        listView.currentIndex = selectedIndex;
        listView.positionViewAtBeginning();
    }

    // Launch app, calculation, or web search
    function launchApp(idx) {
        if (idx < 0 || idx >= filteredModel.count)
            return ;

        const app = filteredModel.get(idx);
        if (app.isCalc)
            return ;
 // Calculations are displayed only
        if (app.isWeb)
            Quickshell.execDetached(["xdg-open", app.exec]);
        else
            Quickshell.execDetached(["bash", "-c", app.exec + " &"]);
        closeLauncher();
    }

    // Close the launcher
    function closeLauncher() {
        Globals.visiblility.launcher = false;
    }

    // Reset the search
    function resetSearch() {
        searchQuery = "";
        updateFilter();
        selectedIndex = -1;
        listView.currentIndex = -1;
    }

    anchors.fill: parent
    opacity: Globals.visiblility.launcher ? 1 : 0
    anchors.margins: 10
    Component.onCompleted: reloadApps()

    // All installed apps
    ListModel {
        id: appModel
    }

    // Filtered apps for display
    ListModel {
        id: filteredModel
    }

    // Runs script to populate appModel
    Process {
        id: appLoader

        running: true
        command: ["bash", "-c", Directories.scriptsPath + "/finders/find-apps.sh"]

        stdout: SplitParser {
            onRead: (data) => {
                const lines = data.split("\n");
                for (let i = 0; i < lines.length; ++i) {
                    const line = lines[i].trim();
                    if (!line)
                        continue;

                    const parts = line.split("|");
                    if (parts.length >= 4) {
                        const displayName = parts[0].trim();
                        appModel.append({
                            "name": displayName,
                            "displayName": displayName,
                            "comment": parts[1].trim(),
                            "icon": parts[2].trim(),
                            "exec": parts[3].trim(),
                            "isCalc": false,
                            "isWeb": false
                        });
                    }
                }
                updateFilter();
            }
        }

    }

    // Main UI layout
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

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

                // Delegate for each app / calculation / web search
                delegate: Rectangle {
                    property bool isSelected: listView.currentIndex === index

                    width: listView.width
                    height: 60
                    radius: Appearance.rounding.normal
                    color: isSelected ? Appearance.m3colors.m3surfaceContainerHighest : "transparent"

                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 12

                        Item {
                            width: 32
                            height: 32

                            // Show app icon if normal app
                            Image {
                                anchors.fill: parent
                                visible: !model.isCalc && !model.isWeb
                                smooth: true
                                mipmap: true
                                antialiasing: true
                                fillMode: Image.PreserveAspectFit
                                sourceSize.width: 128
                                sourceSize.height: 128
                                source: model.icon && model.icon.startsWith("/") ? model.icon : ""
                            }

                            // Calculator icon for calculations
                            MaterialSymbol {
                                anchors.centerIn: parent
                                visible: model.isCalc
                                icon: "calculate"
                                iconSize: 28
                                color: Appearance.m3colors.m3onSurfaceVariant
                            }

                            // Web search icon
                            MaterialSymbol {
                                anchors.centerIn: parent
                                visible: model.isWeb
                                icon: "public"
                                iconSize: 28
                                color: Appearance.m3colors.m3onSurfaceVariant
                            }

                        }

                        // App / calculation / web search text
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

    // Fade animation when launcher opens/closes
    Behavior on opacity {
        enabled: Config.runtime.appearance.animations.enabled
        NumberAnimation {
            duration: 400
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animation.curves.standard
        }

    }

}
