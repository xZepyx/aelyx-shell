import qs.services
import qs.widgets 
import qs.settings
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ContentMenu {
    title: "Misc"
    description: "Adjust misc settings."

    ContentCard {
        StyledSwitchOption {
            title: "Notification Daemon";
            description: "Enabled or disable builtin Aelyx notification daemon."
            prefField: "misc.notificationDaemonEnabled"
        }

        StyledSwitchOption {
            title: "Focus Mode";
            description: "Enabled or disable focus mode."
            prefField: "misc.dndEnabled"
        }
    }
}
