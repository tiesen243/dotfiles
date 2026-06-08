import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell
import QtQuick

import qs.Commons

Item {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: background
      required property ShellScreen modelData
      screen: modelData

      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.namespace: "quickshell-background"
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      anchors { top: true; left: true; right: true; bottom: true }
      color: Colors.surface
      exclusiveZone: -1

      ClippingWrapperRectangle {
        anchors.fill: parent
        anchors.topMargin: Settings.bar.position === "top" ? Settings.bar.size : 0
        anchors.leftMargin: Settings.bar.position === "left" ? Settings.bar.size * 2.5 : 0
        anchors.rightMargin: Settings.bar.position === "right" ? Settings.bar.size * 2.5 : 0
        anchors.bottomMargin: Settings.bar.position === "bottom" ? Settings.bar.size : 0

        color: Colors.surface_bright
        radius: Settings.style.radius
        clip: true

        Image {
          anchors.fill: parent
          source: Settings.home + "/dotfiles/assets/_background.png"
          fillMode: Image.PreserveAspectCrop
        }
      }
    }
  }
}
