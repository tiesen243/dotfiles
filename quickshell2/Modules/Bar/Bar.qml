import Quickshell.Wayland
import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.Commons
import qs.Modules.Bar.Widgets

Item {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      required property ShellScreen modelData
      screen: modelData

      WlrLayershell.layer: WlrLayer.Top
      WlrLayershell.namespace: "quickshell-bar"
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      anchors.top: Settings.bar.position !== "bottom" ? true : 0
      anchors.left: Settings.bar.position !== "right" ? true : 0
      anchors.right: Settings.bar.position !== "left" ? true : 0
      anchors.bottom: Settings.bar.position !== "top" ? true : 0
      implicitHeight: Settings.isBarHorizontal ? Settings.bar.size : 0
      implicitWidth: !Settings.isBarHorizontal ? Settings.bar.size * 2.5 : 0
      color: Colors.surface

      AutoLayout {
        id: left
        anchors {
          left: Settings.isBarHorizontal ? parent.left : undefined
          top: !Settings.isBarHorizontal ? parent.top : undefined
          verticalCenter: Settings.isBarHorizontal ? parent.verticalCenter : undefined
          horizontalCenter: !Settings.isBarHorizontal ? parent.horizontalCenter : undefined
          margins: Settings.style.margin
        }

        Logo {}
      }

      AutoLayout {
        id: center
        anchors {
          horizontalCenter: parent.horizontalCenter
          verticalCenter: parent.verticalCenter
          margins: Settings.style.margin
        }

        Loader {
          active: Settings.isHyprland
          visible: active
          sourceComponent: HyprlandWorkspaces {}
        }

        Loader {
          active: Settings.isNiri
          visible: active
          sourceComponent: NiriWorkspaces {}
        }
      }

      AutoLayout {
        id: right
        anchors {
          right: Settings.isBarHorizontal ? parent.right : undefined
          bottom: !Settings.isBarHorizontal ? parent.bottom : undefined
          verticalCenter: Settings.isBarHorizontal ? parent.verticalCenter : undefined
          horizontalCenter: !Settings.isBarHorizontal ? parent.horizontalCenter : undefined
          margins: Settings.style.margin
        }

        Tray {}

        Clock {}
      }
    }
  }
}
