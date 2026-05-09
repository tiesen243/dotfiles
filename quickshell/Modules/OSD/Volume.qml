import QtQuick.Layouts
import QtQuick

import "../../Services"

Rectangle {
  id: root
  property font rootFont

  width: 36
  height: 200
  radius: 24
  color: Matugen.surface
  border { color: Matugen.on_primary; width: 2 }
  opacity: VolumeService.isShow ? 1 : 0

  Behavior on opacity { NumberAnimation { duration: 150 } }

  Accessible.role: Accessible.ProgressBar
  Accessible.name: VolumeService.isMuted ? "Volume: muted" : "Volume: " + Math.round(VolumeService.value * 100) + "%"

  ColumnLayout {
    anchors.fill: parent
    anchors.topMargin: 12
    anchors.bottomMargin: 12
    anchors.leftMargin: 0
    anchors.rightMargin: 0
    spacing: 8

    Text {
      text: Math.round(VolumeService.value * 100).toString().padStart(2, '0')
      color: Matugen.secondary
      font { pixelSize: root.rootFont.pixelSize * 0.8; family: root.rootFont.family }
      Layout.alignment: Qt.AlignHCenter
    }

    Rectangle {
      Layout.fillHeight: true
      Layout.alignment: Qt.AlignHCenter

      width: 8
      radius: 4
      color: Matugen.surface
      border { color: Matugen.on_primary; width: 2 }
      clip: true

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 2
        height: Math.max(0, (parent.height - 4) * Math.max(0, Math.min(1, VolumeService.value)))
        radius: 3
        color: VolumeService.isMuted ? Matugen.secondary : Matugen.primary

        Behavior on height { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
      }
    }

    Text {
      text: VolumeService.getIcon()
      color: VolumeService.isMuted ? Matugen.secondary : Matugen.primary
      font: root.rootFont
      Layout.alignment: Qt.AlignHCenter
    }
  }
}
