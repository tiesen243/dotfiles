pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell
import QtQuick

import "../../Services"

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: background
      required property var modelData
      screen: modelData

      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      anchors { top: true; left: true; right: true; bottom: true }
      exclusiveZone: -1
      color: Matugen.surface

      Image {
        id: backgroundImage

        anchors.fill: parent
        source: BackgroundService.wallpaperDir + "?v=" + BackgroundService.wallpaperVersion
        fillMode: Image.PreserveAspectCrop
        cache: true
        smooth: true
      }

      BackgroundSelector {
        id: backgroundSelector
      }
    }
  }
}
