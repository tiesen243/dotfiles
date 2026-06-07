import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  property font rootFont

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
    color: Matugen.surface
    border { color: Matugen.primary; width: 1 }
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
        color: Matugen.secondary
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
          color: Matugen.secondary
          font: root.rootFont
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
          color: Matugen.primary
          font {
            pixelSize: root.rootFont.pixelSize * 1.25
            family: root.rootFont.family
            bold: true
          }
          elide: Text.ElideRight
        }

        Text {
          Accessible.role: Accessible.StaticText
          Accessible.name: root.activePlayer ? "Track artist: " + (root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : "unknown artist") : "No active player"

          Layout.fillWidth: true
          text: root.activePlayer && root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : "" 
          color: Matugen.primary
          font: root.rootFont
          elide: Text.ElideRight
          visible: text !== ""
        }
      }
    }
  }
}
