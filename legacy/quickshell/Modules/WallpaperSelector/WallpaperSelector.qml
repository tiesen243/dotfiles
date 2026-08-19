import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Services

Scope {
  id: root

  IpcHandler {
    target: "wallpaper-selector"

    function toggle() {
      GlobalState.toggleWallpaperSelector()
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: wallpaperSelector
      required property ShellScreen modelData
      screen: modelData

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "quickshell-wallpaper-selector"
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      WlrLayershell.exclusiveZone: -1
      visible: GlobalState.isWallpaperSelectorVisible || wallpaperSelectorContainer.implicitHeight > 0

      anchors { left: true; right: true; bottom: true }
      implicitHeight: 1080 / 4
      color: "transparent"

      Rectangle {
        id: wallpaperSelectorContainer
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        implicitHeight: GlobalState.isWallpaperSelectorVisible ? parent.height : 0
        color: Colors.surface

        Behavior on implicitHeight {
          id: heightAnimation
          NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        ListView {
          id: wallpaperList
          model: Background.wallpapers

          anchors.fill: parent
          anchors.margins: Settings.style.margin
          boundsBehavior: Flickable.StopAtBounds
          orientation: ListView.Horizontal
          spacing: Settings.style.margin
          clip: true

          delegate: ClippingRectangle {
            id: wallpaperItem

            readonly property real targetWidth: (1920 / 4) - Settings.style.margin * 2
            property real targetHeight: wallpaperSelector.implicitHeight - Settings.style.margin * 2

            implicitWidth: targetWidth
            implicitHeight: targetHeight
            radius: Settings.style.radius
            clip: true
            color: Colors.surface_bright

            Image {
              anchors.fill: parent
              source: modelData
              fillMode: Image.PreserveAspectCrop
              sourceSize: Qt.size(wallpaperItem.targetWidth / 2, wallpaperItem.targetHeight / 2)
              asynchronous: true
              cache: true
            }

            MouseArea {
              enabled: GlobalState.isWallpaperSelectorVisible && !heightAnimation.running
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: Background.setWallpaper(modelData)
            }
          }
        }
      }
    }
  }
}
