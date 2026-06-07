import QtQuick

import qs.Commons

Item {
  id: root

  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  Text {
    id: icon
    Accessible.role: Accessible.Button
    Accessible.name: "Control center trigger"

    anchors.centerIn: parent
    anchors.verticalCenter: parent.verticalCenter

    text: ""
    font: Settings.getFont(14, true)
    color: Colors.on_surface

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: GlobalState.toggleControlCenter()
    }
  }
}
