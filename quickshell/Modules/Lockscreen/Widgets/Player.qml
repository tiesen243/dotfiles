import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Services

Item {
  id: root

  implicitHeight: lockscreenPlayer.implicitHeight
  visible: Player.activePlayer !== null

  Rectangle {
    id: lockscreenPlayer

    anchors.horizontalCenter: parent.horizontalCenter
    implicitWidth: 600
    implicitHeight: playerInfo.implicitHeight + 32
    color: Colors.surface
    border { color: Colors.primary; width: 1 }
    radius: 16

    RowLayout {
      id: playerInfo
      anchors.fill: parent
      anchors.margins: 16
      spacing: 16

      ClippingRectangle {
        id: albumArt

        implicitWidth: 64
        implicitHeight: implicitWidth
        color: Colors.secondary
        radius: Settings.style.radius

        Image {
          id: trackAlbumImage
          Accessible.role: Accessible.Graphic
          Accessible.name: Player.activePlayer ? "Album art for " + Player.trackTitle : "No active media player"

          anchors.fill: parent
          source: Player.trackArtUrl || ""
          fillMode: Image.PreserveAspectCrop
          visible: source != ""
        }

        Text {
          id: trackAlbumFallback
          Accessible.role: Accessible.StaticText
          Accessible.name: Player.activePlayer ? "No album art available for " + Player.trackTitle : "No active media player"

          anchors.centerIn: parent
          text: "󰎆"
          color: Colors.on_secondary
          font: Settings.getFont(20)
          visible: trackAlbumImage.status != Image.Ready
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Text {
          Accessible.role: Accessible.StaticText
          Accessible.name: Player.activePlayer ? "Track title: " + Player.trackTitle : "No active player"

          Layout.fillWidth: true
          text: Player.trackTitle
          color: Colors.primary
          font: Settings.getFont(18, true)
          elide: Text.ElideRight
        }

        Text {
          Accessible.role: Accessible.StaticText
          Accessible.name: Player.activePlayer ? "Artist(s): " + Player.trackArtist : "No active player"

          Layout.fillWidth: true
          text: Player.trackArtist
          color: Colors.primary
          font: Settings.getFont()
          elide: Text.ElideRight
          visible: text !== ""
        }
      }
    }
  }
}
