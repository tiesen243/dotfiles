import QtQuick
import QtQuick.Layouts
import qs.Colors

Rectangle {
  id: root
  property font rootFont

  property bool showBrightness: false
  property real brightnessValue: 0

  Colors { id: colors }

  width: 36
  height: 200
  radius: 24
  color: colors.surface
  border { color: colors.on_primary; width: 1 }
  opacity: showBrightness ? 1 : 0

  Behavior on opacity { NumberAnimation { duration: 150 } }

  Accessible.role: Accessible.ProgressBar
  Accessible.name: "Brightness: " + Math.round(brightnessValue * 100) + "%"

  ColumnLayout {
    anchors.fill: parent
    anchors.topMargin: 12
    anchors.bottomMargin: 12
    anchors.leftMargin: 0
    anchors.rightMargin: 0
    spacing: 8

    Text {
      text: Math.round(root.brightnessValue * 100) + "%"
      color: colors.secondary
      font { pixelSize: root.rootFont.pixelSize * 0.8; family: root.rootFont.family }
      Layout.alignment: Qt.AlignHCenter
    }

    Rectangle {
      Layout.fillHeight: true
      Layout.alignment: Qt.AlignHCenter
      width: 8
      radius: 4
      color: colors.surface
      border { color: colors.on_primary; width: 1 }
      clip: true

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 2
        height: Math.max(0, (parent.height - 4) * Math.max(0, Math.min(1, root.brightnessValue)))
        radius: 3
        color: colors.primary

        Behavior on height { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
      }
    }

    Text {
      text: "󰃠"
      color: colors.primary
      font: root.rootFont
      Layout.alignment: Qt.AlignHCenter
    }
  }
}
