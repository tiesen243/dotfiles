import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell
import QtQuick

import "../Services"

Scope {
  id: root
  property bool isBorder: Quickshell.env("AROUND_BORDER") === "1"

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
        anchors.margins: root.isBorder ? 8 : 0
        anchors.topMargin: root.isBorder ? 28 : 0
        color: Matugen.on_primary
        radius: root.isBorder ? 12 : 0
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
