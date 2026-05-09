import Quickshell.Wayland
import Quickshell
import QtQuick

import "../../Services"

Scope {
  id: root
  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      visible: VolumeService.isShow || BrightnessService.isShow
      focusable: false
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      WlrLayershell.namespace: "quickshell-osd"

      exclusionMode: ExclusionMode.Ignore
      mask: Region {}

      anchors { right: true; top: true; bottom: true }
      implicitWidth: 70

      Column {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Volume {
          id: volumePill
          rootFont: root.rootFont
        }

        Brightness {
          id: brightnessPill
          rootFont: root.rootFont
        }
      }
    }
  }
}
