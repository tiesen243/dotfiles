import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick

import qs.Commons

Item {
  id: root

  implicitHeight: lockscreenPlayer.implicitHeight

  property var activePlayer: {
    const players = Mpris.players.values;
    if (!players || players.length === 0) return null;

    for (const player of players)
      if (player.playbackState === MprisPlaybackState.Playing) return player;
    return players[0];
  }

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
        radius: 8

        Image {
          id: trackAlbumImage
          Accessible.role: Accessible.Graphic
          Accessible.name: root.activePlayer ? "Album art for " + (root.activePlayer.metadata["xesam:title"] || "unknown track") : "No active media player"

          anchors.fill: parent
          source: root.activePlayer && root.activePlayer.trackArtUrl ? root.activePlayer.trackArtUrl : ""
          fillMode: Image.PreserveAspectCrop
          visible: root.activePlayer && root.activePlayer.trackArtUrl !== ""
        }

        Text {
          id: trackAlbumFallback
          Accessible.role: Accessible.StaticText
          Accessible.name: root.activePlayer ? "No album art available for " + (root.activePlayer.metadata["xesam:title"] || "unknown track") : "No active media player"

          anchors.centerIn: parent
          text: "󰎆"
          color: Colors.secondary
          font: Settings.getFont()
          visible: root.activePlayer && root.activePlayer.trackArtUrl === ""
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Text {
          Accessible.role: Accessible.StaticText
          Accessible.name: root.activePlayer ? "Current track: " + (root.activePlayer.metadata["xesam:title"] || "unknown title") : "No active player"

          Layout.fillWidth: true
          text: root.activePlayer ? root.activePlayer.metadata["xesam:title"] || "Unknown Title" : "No active player"
          color: Colors.primary
          font: Settings.getFont(18, true)
          elide: Text.ElideRight
        }

        Text {
          Accessible.role: Accessible.StaticText
          Accessible.name: root.activePlayer ? "Track artist: " + (root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : "unknown artist") : "No active player"

          Layout.fillWidth: true
          text: root.activePlayer && root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : "" 
          color: Colors.primary
          font: Settings.getFont()
          elide: Text.ElideRight
          visible: text !== ""
        }
      }
    }
  }
}
