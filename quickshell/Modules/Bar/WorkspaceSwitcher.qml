import Quickshell.Hyprland

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
  id: workspaceSwitcher


  Repeater {
    model: 9

    Text {
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
      text: index + 1
      color: isActive ? colors.primary : colors.secondary
      font { pixelSize: bar.fontSize; family: bar.fontFamily; bold: isActive }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("workspace " + (index + 1))
      }
    }
  }
}
