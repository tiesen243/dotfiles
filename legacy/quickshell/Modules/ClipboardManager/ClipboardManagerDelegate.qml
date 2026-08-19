pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Commons

Rectangle {
  id: clipItem
  
  required property var modelData
  property bool isCurrent: ListView.isCurrentItem

  signal clicked()

  implicitWidth: ListView.view ? ListView.view.width : 0
  implicitHeight: (modelData && modelData.type === "IMAGE") ? 110 : (clipText.implicitHeight + 24)
  
  color: isCurrent ? Colors.surface_bright : "transparent"
  border { color: isCurrent ? Colors.primary : Colors.border; width: 1 }
  radius: Settings.style.radius

  RowLayout {
    anchors { 
      left: parent.left
      right: parent.right
      verticalCenter: parent.verticalCenter 
      margins: Settings.style.margin
    }
    spacing: Settings.style.margin

    Text {
      text: (modelData && modelData.type === "IMAGE") ? "󰋩" : ""
      font: Settings.getFont()
      color: clipItem.isCurrent ? Colors.primary : Colors.on_surface
    }

    StackLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      currentIndex: (modelData && modelData.type === "IMAGE") ? 1 : 0

      Text {
        id: clipText
        text: modelData ? modelData.content : ""
        color: clipItem.isCurrent ? Colors.primary : Colors.on_surface
        font: Settings.getFont()
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
      }

      Image {
        source: (modelData && modelData.type === "IMAGE") ? ("file://" + modelData.content) : ""
        fillMode: Image.PreserveAspectFit
        Layout.preferredWidth: 120
        Layout.preferredHeight: 80
        asynchronous: true
        cache: true

        Layout.alignment: Qt.AlignLeft
        horizontalAlignment: Image.AlignLeft
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: clipItem.clicked()
  }
}
