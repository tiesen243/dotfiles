pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Widgets
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

      ClippingRectangle {
        anchors.fill: parent
        anchors.margins: 8
        anchors.topMargin: 28
        radius: 12

        Image {
          id: backgroundImage

          anchors.fill: parent
          source: BackgroundService.wallpaperDir + "?v=" + BackgroundService.wallpaperVersion
          fillMode: Image.PreserveAspectCrop
          cache: true
          smooth: true
        }
      }

      BackgroundSelector {
        id: backgroundSelector
      }
    }
  }
}
