import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  RowLayout {
    id: workspace
    anchors.verticalCenter: parent.verticalCenter
    
    Repeater {
      model: Hyprland.workspaces

      Rectangle {
        id: workspaceItem
        required property var modelData
        Accessible.role: Accessible.Button
        Accessible.name: "Workspace " + modelData.id + (modelData.focused ? ", active" : "") + (modelData.urgent ? ", urgent" : "")

        implicitWidth: rootFont.pixelSize * 1.5
        implicitHeight: rootFont.pixelSize * 1.5
        color: modelData.focused ? colors.primary : colors.surface
        radius: 4

        Behavior on color {
          ColorAnimation { duration: 150 }
        }

        Text {
          id: workspaceLabel

          text: modelData.id
          color: modelData.focused ? colors.on_primary : colors.on_surface
          font: rootFont
          anchors.centerIn: parent
        }
      }
    }
  }

}
