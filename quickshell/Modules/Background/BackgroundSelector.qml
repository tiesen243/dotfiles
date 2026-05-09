pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick

import "../../Services"

PanelWindow {
  id: root
  visible: BackgroundService.isOpen

  IpcHandler {
    target: 'wallpaper'

    function toggle() {
      BackgroundService.isOpen = !BackgroundService.isOpen
    }
  }

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  anchors { top: true; left: true; right: true; bottom: true }
  color: "transparent"

  Rectangle {
    id: selector

    anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 8 } 
    implicitHeight: 232
    color: Matugen.surface
    radius: 8
    border { color: Matugen.on_primary; width: 1 }

    ListView {
      id: wallpaperList
      anchors.fill: parent
      anchors.margins: 16
      spacing: 8
      orientation: Qt.Horizontal
      clip: true

      model: BackgroundService.wallpapers
      delegate: Rectangle {
        id: wallpaperItem
        required property var modelData

        implicitWidth: implicitHeight * 16 / 9
        implicitHeight: 200
        color: Matugen.secondary

        Image {
          anchors.fill: parent
          source: wallpaperItem.modelData
          fillMode: Image.PreserveAspectCrop
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            BackgroundService.setWallpaper(wallpaperItem.modelData)
            BackgroundService.isOpen = false
          }
        }
      }
    }
  }
}
