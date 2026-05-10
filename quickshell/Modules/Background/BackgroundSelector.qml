pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell
import QtQuick

import "../../Services"

PanelWindow {
  id: root
  visible: GlobalState.isBackgroundSelectorOpen || selector.implicitHeight > 0

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  WlrLayershell.exclusiveZone: -1

  anchors { left: true; right: true; bottom: true }
  implicitHeight: 232
  color: "transparent"

  Region { id: clickCatcher }
  mask: visible ? null : clickCatcher

  HyprlandFocusGrab {
    active: GlobalState.isBackgroundSelectorOpen
    windows: [root]
    onCleared: GlobalState.isBackgroundSelectorOpen = false
  }

  Rectangle {
    id: selector

    anchors.bottom: parent.bottom
    implicitWidth: parent.width
    implicitHeight: GlobalState.isBackgroundSelectorOpen ? parent.height : 0
    color: Matugen.surface

    Behavior on implicitHeight {
      NumberAnimation {
        id: heightAnimation
        duration: 250; 
        easing.type: Easing.OutCubic 
      }
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
        radius: 12

        Image {
          anchors.fill: parent
          source: wallpaperItem.modelData
          fillMode: Image.PreserveAspectCrop
          sourceSize: Qt.size(355, 200)
          asynchronous: true
        }

        MouseArea {
          enabled: GlobalState.isBackgroundSelectorOpen && !heightAnimation.running
          anchors.fill: parent
          onClicked: {
            BackgroundService.setWallpaper(wallpaperItem.modelData)
            GlobalState.isBackgroundSelectorOpen = false
          }
        }
      }
    }
  }
}
