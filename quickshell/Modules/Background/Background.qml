import QtQuick
import QtCore

import Quickshell
import Quickshell.Wayland

import qs.Colors

Scope {
  id: root

  Colors { id: colors }

  function getWallpaper(fileName: string): string {
    return StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] + "/dotfiles/assets/" + fileName
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: background
      required property var modelData
      screen: modelData

      WlrLayershell.layer: WlrLayershell.Background
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
}
