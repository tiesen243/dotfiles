pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Commons

Rectangle {
  id: appItem
  
  required property var modelData
  property bool isCurrent: ListView.isCurrentItem

  signal clicked()

  Accessible.role: Accessible.ListItem
  Accessible.name: modelData ? modelData.name : ""

  implicitWidth: ListView.view ? ListView.view.width : 0
  implicitHeight: appText.implicitHeight + Settings.style.margin * 3
  
  color: isCurrent ? Colors.surface_bright : "transparent"
  border { 
    color: isCurrent ? Colors.primary : Colors.border
    width: 1 
  }
  radius: Settings.style.radius

  RowLayout {
    anchors { 
      left: parent.left
      right: parent.right
      verticalCenter: parent.verticalCenter 
      margins: Settings.style.margin
    }

    Image {
      id: appIcon
      visible: appItem.modelData && appItem.modelData.icon !== ""
      source: appItem.modelData ? appItem.modelData.icon : ""
      sourceSize: Qt.size(24, 24)
    }

    Text {
      id: appText
      Layout.fillWidth: true
      text: appItem.modelData ? appItem.modelData.name : ""
      color: appItem.isCurrent ? Colors.primary : Colors.on_surface
      font: Settings.getFont()
      elide: Text.ElideRight
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: appItem.clicked()
  }
}
