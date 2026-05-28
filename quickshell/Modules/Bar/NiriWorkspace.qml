pragma ComponentBehavior: Bound

import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  property font rootFont

  implicitWidth: workspace.implicitWidth
  implicitHeight: workspace.implicitHeight

  RowLayout {
    id: workspace
    
    Repeater {
      model: Niri.workspaces

      Rectangle {
        id: workspaceItem
        required property var modelData
        Accessible.role: Accessible.Button
        Accessible.name: "Workspace " + modelData.id + (modelData.is_focused ? ", active" : "") + (modelData.is_urgent ? ", urgent" : "")

        implicitWidth: root.rootFont.pixelSize * (modelData.is_focused ? 2 : 1.5)
        implicitHeight: root.rootFont.pixelSize * 1.5
        color: modelData.is_focused ? Matugen.primary : (workspaceItemMouseArea.containsMouse 
          ? Matugen.on_secondary : Matugen.surface_bright)
        radius: 4

        Behavior on color {
          ColorAnimation { duration: 150 }
        }

        Behavior on width {
          NumberAnimation { duration: 150 }
        }

        Text {
          id: workspaceLabel

          text: workspaceItem.modelData
          color: workspaceItem.modelData.is_focused 
            ? Matugen.on_primary 
            : Matugen.on_surface
          font: root.rootFont
          anchors.centerIn: parent

          Behavior on color {
            ColorAnimation { duration: 150 }
          }
        }

        MouseArea {
          id: workspaceItemMouseArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: Niri.switchToWorkspace(workspaceItem.modelData.id)
        }
      }
    }
  }
}
