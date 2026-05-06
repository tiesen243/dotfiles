import QtQuick
import QtQuick.Layouts
import qs.Colors

Rectangle {
  id: root
  property font rootFont

  property bool showVolume: false
  property real volumeValue: 0
  property bool volumeMuted: false

  Colors { id: colors }

  width: 36
  height: 200
  radius: 24
  color: colors.surface
  border { color: colors.on_primary; width: 2 }
  opacity: showVolume ? 1 : 0

  Behavior on opacity { NumberAnimation { duration: 150 } }

  Accessible.role: Accessible.ProgressBar
  Accessible.name: volumeMuted ? "Volume: muted" : "Volume: " + Math.round(volumeValue * 100) + "%"

  ColumnLayout {
    anchors.fill: parent
    anchors.topMargin: 12
    anchors.bottomMargin: 12
    anchors.leftMargin: 0
    anchors.rightMargin: 0
    spacing: 8

    Text {
      text: root.volumeMuted ? "Mute" : Math.round(root.volumeValue * 100) + "%"
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
      border { color: colors.on_primary; width: 2 }
      clip: true

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 2
        height: Math.max(0, (parent.height - 4) * Math.max(0, Math.min(1, root.volumeMuted ? 0 : root.volumeValue)))
        radius: 3
        color: root.volumeMuted ? colors.secondary : colors.primary

        Behavior on height { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
      }
    }

    Text {
      text: {
        if (root.volumeMuted || root.volumeValue <= 0) return "󰖁";
        if (root.volumeValue < 0.33) return "󰕿";
        if (root.volumeValue < 0.66) return "󰖀";
        return "󰕾";
      }
      color: root.volumeMuted ? colors.secondary : colors.primary
      font: root.rootFont
      Layout.alignment: Qt.AlignHCenter
    }
  }
}
