import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Services

Rectangle {
  id: root

  width: 36
  height: 200
  radius: 16
  color: Colors.surface
  border { color: Colors.on_primary; width: 1 }
  opacity: Volume.isShow ? 1 : 0

  Behavior on opacity { NumberAnimation { duration: 150 } }

  Accessible.role: Accessible.ProgressBar
  Accessible.name: "Volume: " + Math.round(Volume.value * 100) + "%" + (Volume.isMuted ? ", muted" : "")

  ColumnLayout {
    anchors.fill: parent
    anchors.topMargin: 12
    anchors.bottomMargin: 12
    anchors.leftMargin: 0
    anchors.rightMargin: 0
    spacing: 8

    Text {
      Layout.alignment: Qt.AlignHCenter

      text: Math.round(Volume.value * 100).toString().padStart(2, '0')
      color: Colors.secondary
      font: Settings.getFont(12)
    }

    Rectangle {
      Layout.fillHeight: true
      Layout.alignment: Qt.AlignHCenter

      width: 8
      radius: 4
      color: Colors.surface
      border { color: Colors.on_primary; width: 1 }
      clip: true

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 2
        height: Math.max(0, (parent.height - 4) * Math.max(0, Math.min(1, Volume.value)))
        radius: 3
        color: Volume.isMuted ? Colors.secondary : Colors.primary

        Behavior on height { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
      }
    }

    Text {
      Layout.alignment: Qt.AlignHCenter

      text: Volume.getIcon()
      color: Volume.isMuted ? Colors.secondary : Colors.primary
      font: Settings.getFont()
    }
  }
}
