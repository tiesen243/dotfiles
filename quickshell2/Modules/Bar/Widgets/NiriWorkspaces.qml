import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Services

Item {
  id: root

  implicitWidth: workspaces.implicitWidth
  implicitHeight: workspaces.implicitHeight

  AutoLayout {
    id: workspaces

    Repeater {
      model: Niri.workspaces

      Rectangle {
        id: workspaceItem
        required property var modelData
        Accessible.role: Accessible.Button
        Accessible.name: "Workspace " + modelData.id + (modelData.is_focused ? ", active" : "") + (modelData.is_urgent ? ", urgent" : "")

        implicitWidth: Settings.isBarHorizontal 
          ? modelData.is_focused ? Settings.bar.size * 1.5 : Settings.bar.size / 1.5
          : Settings.bar.size / 2
        implicitHeight: Settings.isBarHorizontal
          ? Settings.bar.size / 2
          : modelData.is_focused ? Settings.bar.size * 1.5 : Settings.bar.size / 1.5
        color: modelData.is_focused ? Colors.on_surface 
          : (workspaceItemMouseArea.containsMouse ? Colors.on_muted : Colors.surface_bright)
        radius: Settings.style.radius

        MouseArea {
          id: workspaceItemMouseArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: workspaceItem.modelData.is_focused ? 
            Niri.toggleOverview() :
            Niri.switchToWorkspace(workspaceItem.modelData.id)
          cursorShape: Qt.PointingHandCursor
        }
      }
    }
  }
}
