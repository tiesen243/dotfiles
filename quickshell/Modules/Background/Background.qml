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

      anchors.top: true
      anchors.left: true
      anchors.right: true
      anchors.bottom: true

      exclusiveZone: -1
      color: Matugen.surface

      Image {
        id: backgroundImage

        anchors.fill: parent
        cache: true
        smooth: true

        source: GlobalState.dotfiles + "/assets/_background.png"
        fillMode: Image.PreserveAspectCrop
      }
    }
  }
}
