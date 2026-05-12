import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell
import QtQuick

import "../Services"

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: background
      required property var modelData
      screen: modelData
      visible: true

      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.namespace: "quickshell-background"
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      anchors { top: true; left: true; right: true; bottom: true }
      exclusiveZone: -1
      color: Matugen.surface

      ClippingWrapperRectangle {
        anchors.fill: parent
        anchors.margins: 8
        anchors.topMargin: 28
        color: Matugen.on_primary
        radius: 12
        clip: true

        Image {
          anchors.fill: parent
          source: BackgroundService.wallpaperDir + "?v=" + BackgroundService.wallpaperVersion
          fillMode: Image.PreserveAspectCrop
        }
      }
    }
  }
}
