import qs.config
import qs.widgets
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects

PanelWindow {
  id: root

  color: "transparent"
  property bool isEnabled: (Config.options.background.borderEnabled ? true : false) && Config.ready
  visible: isEnabled
  WlrLayershell.layer: WlrLayer.Top

  mask: Region { item: container; intersection: Intersection.Xor }

  anchors {
    top: true
    left: true
    bottom: true
    right: true
  }

  Item {
    id: container 
    anchors.fill: parent

    StyledRect {
      anchors.fill: parent

      color: Appearance.m3colors.m3background

      layer.enabled: true
      layer.effect: MultiEffect {
        maskSource: mask
        maskEnabled: true
        maskInverted: true
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1
      }
    }
    
    Item {
      id: mask

      anchors.fill: parent
      layer.enabled: true
      visible: false

      StyledRect {
        anchors.fill: parent
        anchors.leftMargin: Appearance.margin.verysmall 
        anchors.rightMargin: Appearance.margin.verysmall
        anchors.topMargin: (Config.options.bar.style === 2)
            ? (Config.options.bar.position === 2
                ? Appearance.margin.normal - 2
                : 1)    // Hugged + Top   
            : (Config.options.bar.style === 1 && Config.options.bar.position === 0)
                ? Appearance.margin.verysmall   // lowered margin when top in style 1
                : 0

        anchors.bottomMargin: (Config.options.bar.style === 2)
            ? (Config.options.bar.position === 1
                ? Appearance.margin.normal - 2  
                : 1)   // Hugged + Bottom
            : (Config.options.bar.style === 1 && Config.options.bar.position === 1)
                ? Appearance.margin.small
                : 0

        radius: Appearance.rounding.normal
      }
    }
  }
}