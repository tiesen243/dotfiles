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
  border { color: Matugen.on_primary; width: 1 }
  opacity: BrightnessService.isShow ? 1 : 0

  Behavior on opacity { NumberAnimation { duration: 150 } }

  Accessible.role: Accessible.ProgressBar
  Accessible.name: "Brightness: " + BrightnessService.value + "%"

  ColumnLayout {
    anchors.fill: parent
    anchors.topMargin: 12
    anchors.bottomMargin: 12
    anchors.leftMargin: 0
    anchors.rightMargin: 0
    spacing: 8

    Text {
      Layout.alignment: Qt.AlignHCenter

      text: BrightnessService.value.toString().padStart(2, '0')
      color: Matugen.secondary
      font { pixelSize: root.rootFont.pixelSize * 0.8; family: root.rootFont.family }
    }

    Rectangle {
      Layout.fillHeight: true
      Layout.alignment: Qt.AlignHCenter

      width: 8
      radius: 4
      color: Matugen.surface
      border { color: Matugen.on_primary; width: 1 }
      clip: true

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 2
        height: Math.max(0, (parent.height - 4) * Math.max(0, Math.min(1, BrightnessService.value / 100)))
        radius: 3
        color: Matugen.primary

        Behavior on height { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
      }
    }

    Text {
      text: BrightnessService.getIcon()
      color: Matugen.primary
      font: root.rootFont
      Layout.alignment: Qt.AlignHCenter
    }
  }
}
