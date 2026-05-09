pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell
import QtQuick
import QtCore

import "../../Services"

Scope {
  id: root
  Colors { id: colors }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: background
      required property var modelData
      screen: modelData

      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      anchors.top: true
      anchors.left: true
      anchors.right: true
      anchors.bottom: true

      exclusiveZone: -1
      color: colors.surface

      Image {
        id: backgroundImage

        anchors.fill: parent
        cache: true
        smooth: true

        source: root.getWallpaper("_background.png")
        fillMode: Image.PreserveAspectCrop
      }
    }
  }

  function getWallpaper(fileName: string): string {
    return StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] + "/dotfiles/assets/" + fileName
  }
}
