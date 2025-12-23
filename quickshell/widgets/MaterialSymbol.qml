import qs.settings
import QtQuick 


StyledText {
    property string icon: ""
    property int iconSize: Appearance.font.size.large
    font.family: Appearance.font.family.materialIcons
    font.pixelSize: iconSize
    text: icon
}