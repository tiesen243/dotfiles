import Quickshell.Services.Mpris

import QtQuick

Item {
  id: player

  property var currentPlayer: Mpris.players.values[0] || null

  function truncateText(text, maxLength) {
    if (text.length <= maxLength) return text
    return text.substring(0, maxLength - 1) + "…"
  }

  Rectangle {
    id: playerContainer

    anchors.fill: parent
    color: "transparent"

    Text {
      id: previousTrackIndicator

      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter

      text: ""
      color: colors.primary
      font { pixelSize: bar.fontSize; family: bar.fontFamily }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          if (player.currentPlayer && player.currentPlayer.canGoPrevious)
            player.currentPlayer.previous()
        }
      }
    }

    Text {
      id: playerContent

      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: previousTrackIndicator.width + 12

      text: {
        if (!player.currentPlayer || !player.currentPlayer.metadata)
            return "No player"

        var title = player.currentPlayer.metadata["xesam:title"] || "Unknown Title"
        var artist = player.currentPlayer.metadata["xesam:artist"] || ""
        if (Array.isArray(artist))
          artist = artist.join(", ")

        var text = title
        if (artist) text = artist + " - " + title

        if (player.currentPlayer.playbackState === MprisPlaybackState.Playing)
          text = " " + text
        else if (player.currentPlayer.playbackState === MprisPlaybackState.Paused)
          text = " " + text
            
        return truncateText(text, 24)
      }
      color: colors.primary
      font { pixelSize: bar.fontSize; family: bar.fontFamily }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          if (!player.currentPlayer)
            return

          if (player.currentPlayer.playbackState === MprisPlaybackState.Playing && player.currentPlayer.canPause) 
            player.currentPlayer.pause()
          else player.currentPlayer.play()
        }
      }
    } 


    Text {
      id: nextTrackIndicator

      anchors.left: playerContent.left
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: previousTrackIndicator.width + playerContent.width + 12

      text: ""
      color: colors.primary
      font { pixelSize: bar.fontSize; family: bar.fontFamily }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          if (player.currentPlayer && player.currentPlayer.canGoNext)
            player.currentPlayer.next()
        }
      }
    }
  }
}

