pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick

import "../../Services"

PanelWindow {
  id: root
  visible: BackgroundService.isOpen || selector.opacity > 0

  IpcHandler {
    target: 'wallpaper'

    function toggle() {
      BackgroundService.isOpen = !BackgroundService.isOpen
    }
  }

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  WlrLayershell.exclusiveZone: -1

  anchors { left: true; right: true; bottom: true }
  implicitHeight: selector.implicitHeight
  color: "transparent"

  Region { id: clickCatcher }
  mask: visible ? null : clickCatcher

  Rectangle {
    id: selector

    implicitWidth: parent.width
    implicitHeight: 232
    color: Matugen.surface

    opacity: BackgroundService.isOpen ? 1 : 0
    Behavior on opacity {
      NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
    }
    y: BackgroundService.isOpen ? 0 : implicitHeight
    Behavior on y {
      NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
    }

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
