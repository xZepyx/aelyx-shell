import qs.settings
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
  visible: Shell.ready 
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
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        radius: Appearance.rounding.normal
      }
    }
  }
}