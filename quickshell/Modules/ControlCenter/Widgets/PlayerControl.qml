import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Services

Item {
  id: root

  Layout.fillWidth: true
  implicitHeight: 120
  visible: Player.activePlayer !== null

  Rectangle {
    id: playerControl

    anchors.fill: parent
    color: Colors.on_primary
    radius: Settings.style.radius

    RowLayout {
      id: playerControlContainer
      spacing: Settings.style.margin
      
      anchors.fill: parent
      anchors.margins: Settings.style.margin

      ClippingRectangle {
        id: albumArtContainer
        Accessible.role: Accessible.Graphic
        Accessible.name: Player.track ? "Album art for " + Player.trackLitle : "No track playing"

        Layout.preferredWidth: playerControl.height - Settings.style.margin * 2
        Layout.preferredHeight: Layout.preferredWidth
        
        color: Colors.on_secondary
        radius: Settings.style.radius - Settings.style.margin / 2

        Image {
          id: trackAlbumImage
          anchors.fill: parent

          fillMode: Image.PreserveAspectCrop
          source: Player.trackArtUrl || ""
          visible: source != "" 
        }

        Text {
          id: trackAlbumFallback
          anchors.centerIn: parent

          text: "󰎆"
          color: Colors.secondary
          font: Settings.getFont(24)
          visible: trackAlbumImage.status != Image.Ready 
        }
      }

      ColumnLayout {
        spacing: Settings.style.margin / 2
        
        Layout.fillWidth: true 
        Layout.alignment: Qt.AlignVCenter

        Text {
          text: Player.trackTitle || "Unknown Title"
          color: Colors.on_surface
          font: Settings.getFont()
          
          Layout.fillWidth: true
          elide: Text.ElideRight 
        }

        Text {
          text: Player.trackArtist || "Unknown Artist"
          color: Colors.on_surface
          font: Settings.getFont()
          Layout.fillWidth: true
          elide: Text.ElideRight
        }

        Text {
          text: Player.trackAlbum || "Unknown Album"
          color: Colors.on_surface
          font: Settings.getFont()
          Layout.fillWidth: true
          elide: Text.ElideRight
        }

        Item { Layout.fillHeight: true }

        RowLayout {
          spacing: Settings.style.margin

          Text {
            id: previousButton

            text: ""
            color: Colors.on_surface
            opacity: Player.activePlayer && Player.activePlayer.canGoPrevious ? 1 : 0.5

            MouseArea {
              anchors.fill: parent
              onClicked: Player.playPrevious()
              enabled: Player.activePlayer && Player.activePlayer.canGoPrevious
            }
          }

          Text {
            id: playPauseButton

            text: Player.state === MprisPlaybackState.Playing ? "" : Player.state === MprisPlaybackState.Paused ? "" : ""
            color: Colors.on_surface
            opacity: Player.state !== MprisPlaybackState.Stopped ? 1 : 0.5

            MouseArea {
              anchors.fill: parent
              onClicked: Player.state === MprisPlaybackState.Playing ? Player.pause() : Player.play()
              enabled: Player.state !== MprisPlaybackState.Stopped
            }
          }

          Text {
            id: nextButton

            text: ""
            color: Colors.on_surface
            opacity: Player.activePlayer && Player.activePlayer.canGoNext ? 1 : 0.5

            MouseArea {
              anchors.fill: parent
              onClicked: Player.playNext()
            }
          }

          Slider {
            id: positionControl
            Accessible.role: Accessible.Slider
            Accessible.name: Player.activePlayer ? "Track position slider, current position: " + Utils.formatTime(Player.activePlayer.position) : "Track position slider, no active player"

            Layout.fillWidth: true
            from: 0
            to: Player.trackLength > 0 ? Player.trackLength : 0
            stepSize: 1
            value: (positionControl.pressed || !Player.activePlayer) ? value : Player.activePlayer.position
            onMoved: Player.seek(value)

            background: Rectangle {
              anchors.fill: parent
              color: Colors.on_secondary
              radius: height / 2
            }

            handle: Rectangle {
              x: positionControl.leftPadding + positionControl.visualPosition * (positionControl.availableWidth - width)
              y: positionControl.topPadding + positionControl.availableHeight / 2 - height / 2
              implicitWidth: 16
              implicitHeight: 16
              radius: 8
              color: positionControl.pressed ? Colors.primary : Colors.on_surface
              border { color: Colors.on_secondary; width: 1 }
            }
          }

          Text {
            id: positionLabel

            text: Player.activePlayer ? `${Utils.formatTime(Player.activePlayer.position)} / ${Utils.formatTime(Player.trackLength)}` : "00:00 / 00:00"
            color: Colors.on_surface
            font: Settings.getFont()
          }
        }
      }
    }
  }
}
