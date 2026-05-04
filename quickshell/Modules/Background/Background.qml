import QtQuick
import QtCore

import Quickshell
import Quickshell.Wayland

import qs.Colors

Scope {
  id: background

  Colors { id: colors }

  function getWallpaper(fileName: string): string {
    return StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] + "/dotfiles/assets/" + fileName
  }

  PanelWindow {
    id: backgroundContainer
    WlrLayershell.layer: WlrLayershell.Background
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true

    exclusiveZone: -1
    color: colors.background

    Image {
      id: wallpaper

      anchors.fill: parent
      cache: true

      source: background.getWallpaper("_background.png")
      fillMode: Image.PreserveAspectCrop
    }
  }
}
