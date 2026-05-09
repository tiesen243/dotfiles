pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitWidth: workspace.implicitWidth
  implicitHeight: workspace.implicitHeight

  RowLayout {
    id: workspace
    
    Repeater {
      model: Hyprland.workspaces

      Rectangle {
        id: workspaceItem
        required property var modelData
        Accessible.role: Accessible.Button
        Accessible.name: "Workspace " + modelData.id + (modelData.focused ? ", active" : "") + (modelData.urgent ? ", urgent" : "")

        implicitWidth: root.rootFont.pixelSize * (modelData.focused ? 2 : 1.5)
        implicitHeight: root.rootFont.pixelSize * 1.5
        color: modelData.focused ? colors.primary : (workspaceItemMouseArea.containsMouse 
          ? colors.on_secondary : colors.surface)
        radius: 4

        Behavior on color {
          ColorAnimation { duration: 150 }
        }

        Behavior on width {
          NumberAnimation { duration: 150 }
        }

        Text {
          id: workspaceLabel

          text: workspaceItem.modelData.id
          color: workspaceItem.modelData.focused 
            ? colors.on_primary 
            : colors.on_surface
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
          onClicked: workspaceItem.modelData.activate()
        }
      }
    }
  }

}
