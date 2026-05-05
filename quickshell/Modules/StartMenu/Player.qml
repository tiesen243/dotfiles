import Quickshell.Widgets
import Quickshell.Services.Mpris

import QtQuick
import QtQuick.Layouts

Rectangle {
  id: player

  property var currentPlayer: Mpris.players.values[0] || null

  anchors { 
    top: brightnessControl.bottom; 
    left: parent.left; 
    right: parent.right; 
    margins: 12; 
  }
  implicitHeight: currentPlayer && currentPlayer.metadata ? 80 : 0
  implicitWidth: parent.width - 24
  radius: 8
  color: colors.primary_container
  clip: true

  ClippingRectangle {
    id: clippingRect

    anchors { 
      left: parent.left
      top: parent.top
      bottom: parent.bottom
      margins: 8
    }
    width: height
    radius: 4

    Image {
      id: albumArt
      anchors.fill: parent
      fillMode: Image.PreserveAspectCrop
      source: player.currentPlayer && player.currentPlayer.metadata && player.currentPlayer.metadata["mpris:artUrl"] 
        ? player.currentPlayer.metadata["mpris:artUrl"] 
        : ""
    }
  }


  ColumnLayout {
    id: playerInfo

    anchors { 
      left: clippingRect.right; 
      top: parent.top; 
      bottom: parent.bottom; 
      right: parent.right; 
      margins: 8; 
    }

    Text {
      id: playerContent

      text: player.currentPlayer.metadata["xesam:title"] || "No player"
      color: colors.primary
    }

    Text {
      text: player.currentPlayer.metadata["xesam:artist"] 
        ? player.currentPlayer.metadata["xesam:artist"].join(", ") 
        : ""
      color: colors.primary
    }

    RowLayout {
      spacing: 12


      Text {
        visible: player.currentPlayer && player.currentPlayer.canGoPrevious
        text: ""
        color: colors.primary
        font { pixelSize: startMenu.fontSize; family: startMenu.fontFamily }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            if (player.currentPlayer && player.currentPlayer.canGoPrevious)
              player.currentPlayer.previous()
          }
        }
      }

      Text {
        text: player.currentPlayer.playbackState === MprisPlaybackState.Playing ? "" :
              player.currentPlayer.playbackState === MprisPlaybackState.Paused ? "" : ""
        color: colors.primary
        font { pixelSize: startMenu.fontSize; family: startMenu.fontFamily }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            if (player.currentPlayer.playbackState === MprisPlaybackState.Playing)
              player.currentPlayer.pause()
            else if (player.currentPlayer.playbackState === MprisPlaybackState.Paused)
              player.currentPlayer.play()
          }
        }
      }

      Text {
        visible: player.currentPlayer && player.currentPlayer.canGoNext
        text: ""
        color: colors.primary
        font { pixelSize: startMenu.fontSize; family: startMenu.fontFamily }

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
}
