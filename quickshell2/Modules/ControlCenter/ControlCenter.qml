import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Modules.ControlCenter.Widgets

Item {
  id: root

  IpcHandler {
    target: "control-center"

    function toggle() {
      GlobalState.toggleControlCenter()
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: controlCenter
      required property ShellScreen modelData
      screen: modelData

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "quickshell-control-center"
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      focusable: true
      visible: GlobalState.isControlCenterVisible || (Settings.isBarHorizontal ? 
        controlCenterContainer.implicitHeight > 0 : 
        controlCenterContainer.implicitWidth > 0
      )

      anchors {
        top: Settings.bar.position !== "bottom"
        left: Settings.bar.position !== "right"
        right: Settings.bar.position === "right"
        bottom: Settings.bar.position === "bottom"
      }

      implicitWidth: 1920 / 3
      implicitHeight: 1080 / 2
      color: "transparent"


      Shortcut {
        sequence: "Escape"
        enabled: GlobalState.isControlCenterVisible
        onActivated: GlobalState.isStartMenuOpen = false
      }


      Rectangle {
        id: controlCenterContainer

        implicitWidth: Settings.isBarHorizontal 
          ? parent.width 
          : (GlobalState.isControlCenterVisible ? parent.width : 0)
        implicitHeight: Settings.isBarHorizontal
          ? (GlobalState.isControlCenterVisible ? parent.height : 0)
          : parent.height
        color: Colors.surface
        clip: true

        bottomRightRadius: (Settings.bar.position === "top" || Settings.bar.position === "left") ? Settings.style.radius : 0
        topRightRadius: Settings.bar.position === "bottom" ? Settings.style.radius : 0
        bottomLeftRadius: Settings.bar.position === "right" ? Settings.style.radius : 0

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Settings.style.margin

          Text {
            text: "Control Center"
            color: Colors.on_surface
            font: Settings.getFont()
          }

          Buttons {}

          Item { Layout.fillHeight: true }
        }

        Behavior on implicitHeight {
          enabled: Settings.isBarHorizontal
          NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        Behavior on implicitWidth {
          enabled: !Settings.isBarHorizontal
          NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
      }
    }
  }
}
