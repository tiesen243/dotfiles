import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell
import QtQuick

import qs.Services
import qs.Commons

Scope {
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
          source: Background.wallpaperDir + "?v=" + Background.wallpaperVer
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
          cache: true
          smooth: true
        }
      }
    }
  }
}
