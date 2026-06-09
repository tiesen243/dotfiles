import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick

import qs.Commons

Item {
  id: root

  implicitWidth: workspaces.implicitWidth
  implicitHeight: workspaces.implicitHeight

  AutoLayout {
    id: workspaces

    Repeater {
      model: Hyprland.workspaces

      Rectangle {
        id: workspaceItem
        required property var modelData
        Accessible.role: Accessible.Button
        Accessible.name: "Workspace " + modelData.id + (modelData.focused ? ", active" : "") + (modelData.urgent ? ", urgent" : "")

        visible: modelData.id !== -98
        implicitWidth: Settings.isBarHorizontal 
          ? modelData.focused ? Settings.bar.size * 1.5 : Settings.bar.size / 1.5
          : Settings.bar.size / 2
        implicitHeight: Settings.isBarHorizontal
          ? Settings.bar.size / 2
          : modelData.focused ? Settings.bar.size * 1.5 : Settings.bar.size / 1.5
        color: modelData.focused ? Colors.on_surface 
          : (workspaceItemMouseArea.containsMouse ? Colors.on_muted : Colors.surface_bright)
        radius: Settings.style.radius

        MouseArea {
          id: workspaceItemMouseArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspaceItem.modelData.id} })`)
          cursorShape: Qt.PointingHandCursor
        }
      }
    }
  }
}
