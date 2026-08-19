import Quickshell.Wayland
import Quickshell
import QtQuick

import qs.Services

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      visible: Volume.isShow || Brightness.isShow
      focusable: false
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "quickshell-osd"
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      exclusionMode: ExclusionMode.Ignore

      anchors { right: true; top: true; bottom: true }
      implicitWidth: 70

      Column {
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        VolumeOSD {}

        BrightnessOSD {}
      }
    }
  }
}
