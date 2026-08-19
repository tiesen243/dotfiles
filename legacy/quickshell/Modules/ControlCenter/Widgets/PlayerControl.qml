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
          Accessible.role: Accessible.Graphic
          Accessible.name: Player.track ? "Album art for " + Player.trackTitle : "No track playing"

          anchors.fill: parent
          source: Player.trackArtUrl
          fillMode: Image.PreserveAspectCrop
          visible: source != "" 
        }

        Text {
          id: trackAlbumFallback
          Accessible.role: Accessible.StaticText
          Accessible.name: Player.track ? "No album art available for " + Player.trackTitle : "No track playing"

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
          Accessible.role: Accessible.StaticText
          Accessible.name: Player.track ? "Track title: " + Player.trackTitle : "No track playing"

          text: Player.trackTitle
          color: Colors.on_surface
          font: Settings.getFont()
          
          Layout.fillWidth: true
          elide: Text.ElideRight 
        }

        Text {
          Accessible.role: Accessible.StaticText
          Accessible.name: Player.track ? "Artist(s): " + Player.trackArtist : "No track playing"

          text: Player.trackArtist
          color: Colors.on_surface
          font: Settings.getFont()
          Layout.fillWidth: true
          elide: Text.ElideRight
        }

        Text {
          Accessible.role: Accessible.StaticText
          Accessible.name: Player.track ? "Album: " + Player.trackAlbum : "No track playing"

          text: Player.trackAlbum
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
            Accessible.role: Accessible.Button
            Accessible.name: "Previous track button, " + (Player.activePlayer && Player.activePlayer && Player.activePlayer.canGoPrevious ? "can go to previous track" : "cannot go to previous track")

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
            Accessible.role: Accessible.Button
            Accessible.name: "Play/Pause button, currently " + (Player.state === MprisPlaybackState.Playing ? "playing" : Player.state === MprisPlaybackState.Paused ? "paused" : "stopped")

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
            Accessible.role: Accessible.Button
            Accessible.name: "Next track button, " + (Player.activePlayer && Player.activePlayer && Player.activePlayer.canGoNext ? "can go to next track" : "cannot go to next track")

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
            Accessible.role: Accessible.StaticText
            Accessible.name: Player.activePlayer ? "Current track position: " + Utils.formatTime(Player.activePlayer.position) + " out of " + Utils.formatTime(Player.trackLength) : "Current track position: no active player"

            text: Player.activePlayer ? `${Utils.formatTime(Player.activePlayer.position)} / ${Utils.formatTime(Player.trackLength)}` : "00:00 / 00:00"
            color: Colors.on_surface
            font: Settings.getFont()
          }
        }
      }
    }
  }
}
