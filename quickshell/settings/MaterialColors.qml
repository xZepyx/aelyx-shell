pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import QtCore
import Quickshell
import Quickshell.Io

Singleton {
    id: m3colors
    property string filePath: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.local/share/aelyx/generated/colors.json"
    property alias colors: colorsJsonAdapter
    property bool ready: false

    FileView {
        id: colorsFileView
        path: m3colors.filePath
        watchChanges: true
        onLoaded: m3colors.ready = true
        onFileChanged: colorsFileView.reload()
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) {
                console.warn("MaterialColors: colors.json not found, writing defaults")
                writeAdapter()
            } else {
                console.error("MaterialColors: failed to load colors.json:", error)
            }
        }

        JsonAdapter {
            id: colorsJsonAdapter

            // === Default Matugen color scheme ===
            property string background: "#131313"
            property string error: "#ffb4ab"
            property string error_container: "#93000a"
            property string inverse_on_surface: "#303030"
            property string inverse_primary: "#00677f"
            property string inverse_surface: "#e2e2e2"
            property string on_background: "#e2e2e2"
            property string on_error: "#690005"
            property string on_error_container: "#ffdad6"
            property string on_primary: "#003543"
            property string on_primary_container: "#b7eaff"
            property string on_primary_fixed: "#001f28"
            property string on_primary_fixed_variant: "#004e60"
            property string on_secondary: "#1e333b"
            property string on_secondary_container: "#cfe6f1"
            property string on_secondary_fixed: "#071e26"
            property string on_secondary_fixed_variant: "#344a52"
            property string on_surface: "#e2e2e2"
            property string on_surface_variant: "#c6c6c6"
            property string on_tertiary: "#2c2e4d"
            property string on_tertiary_container: "#e0e0ff"
            property string on_tertiary_fixed: "#171937"
            property string on_tertiary_fixed_variant: "#424465"
            property string outline: "#919191"
            property string outline_variant: "#474747"
            property string primary: "#5cd5fb"
            property string primary_container: "#004e60"
            property string primary_fixed: "#b7eaff"
            property string primary_fixed_dim: "#5cd5fb"
            property string scrim: "#000000"
            property string secondary: "#b3cad4"
            property string secondary_container: "#344a52"
            property string secondary_fixed: "#cfe6f1"
            property string secondary_fixed_dim: "#b3cad4"
            property string shadow: "#000000"
            property string source_color: "#829aa4"
            property string surface: "#131313"
            property string surface_bright: "#393939"
            property string surface_container: "#1f1f1f"
            property string surface_container_high: "#2a2a2a"
            property string surface_container_highest: "#353535"
            property string surface_container_low: "#1b1b1b"
            property string surface_container_lowest: "#0e0e0e"
            property string surface_dim: "#131313"
            property string surface_tint: "#5cd5fb"
            property string surface_variant: "#474747"
            property string tertiary: "#c3c3eb"
            property string tertiary_container: "#424465"
            property string tertiary_fixed: "#e0e0ff"
            property string tertiary_fixed_dim: "#c3c3eb"
        }
    }

    function reload() {
        colorsFileView.reload()
    }
}