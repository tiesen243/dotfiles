pragma ComponentBehavior: Bound

import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  visible: activePlayer !== null
  implicitHeight: playerControl.implicitHeight

  property var activePlayer: {
    const players = Mpris.players.values;
    if (!players || players.length === 0) return null;

    for (const player of players)
      if (player.playbackState === MprisPlaybackState.Playing) return player;
    return players[0];
  }

  Timer {
    id: positionTimer
    interval: 1000
    repeat: true
    running: root.activePlayer !== null && root.activePlayer.isPlaying
    onTriggered: root.activePlayer.positionChanged()
  }

  Rectangle {
    id: playerControl
    Accessible.role: Accessible.Group
    Accessible.name: "Media player controls for " + (root.activePlayer.metadata["xesam:title"] || "unknown track") + " by " + (root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : "unknown artist")

    anchors.fill: parent
    implicitHeight: playerControlContainer.implicitHeight + 24
    color: colors.on_primary
    radius: 8

    RowLayout {
      id: playerControlContainer
      Accessible.role: Accessible.Group
      Accessible.name: "Media player information and controls"

      anchors { fill: parent; margins: 12 }
      spacing: 12

      ClippingRectangle {
        id: trackAlbum
        Accessible.role: Accessible.Image
        Accessible.name: "Album art for " + (root.activePlayer.metadata["xesam:title"] || "unknown track")

        implicitWidth: playerControlContainer.implicitHeight
        implicitHeight: implicitWidth
        color: colors.on_primary_fixed
        radius: 6

        Image {
          id: trackAlbumImage
          Accessible.role: Accessible.Image
          Accessible.name: "Album art for " + (root.activePlayer.metadata["xesam:title"] || "unknown track")

          anchors.fill: parent
          source: root.activePlayer.trackArtUrl
          fillMode: Image.PreserveAspectCrop
          visible: root.activePlayer.trackArtUrl !== ""
        }

        Text {
          id: trackAlbumFallback
          Accessible.role: Accessible.StaticText
          Accessible.name: "No album art available for " + (root.activePlayer.metadata["xesam:title"] || "unknown track")

          anchors.centerIn: parent
          text: "󰎆"
          color: colors.primary
          font: root.rootFont
          visible: root.activePlayer.trackArtUrl === ""
        }
      }

      ColumnLayout {
        id: trackInfoContainer
        Accessible.role: Accessible.Group
        Accessible.name: "Track information for " + (root.activePlayer.metadata["xesam:title"] || "unknown track") + " by " + (root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : "unknown artist")

        spacing: 4

        Text {
          id: trackInfoTitle
          Accessible.role: Accessible.StaticText
          Accessible.name: "Track title: " + (root.activePlayer.metadata["xesam:title"] || "unknown title")

          Layout.fillWidth: true
          text: root.activePlayer.metadata["xesam:title"] || "Unknown Title"
          color: colors.primary
          font: root.rootFont
          elide: Text.ElideRight
        }

        Text {
          id: trackInfoArtist
          Accessible.role: Accessible.StaticText
          Accessible.name: "Track artist: " + (root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : "unknown artist")

          Layout.fillWidth: true
          text: root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : ""
          color: colors.primary
          font: root.rootFont
          elide: Text.ElideRight
        }

        Item { Layout.fillHeight: true }

        RowLayout {
          id: trackTimeline
          Accessible.role: Accessible.Group
          Accessible.name: "Track timeline for " + (root.activePlayer.metadata["xesam:title"] || "unknown track")

          spacing: 8

          Text {
            id: trackPosition
            Accessible.role: Accessible.StaticText
            Accessible.name: "Current position in track: " + root.formatTime(root.activePlayer.position)

            text: root.formatTime(root.activePlayer.position)
            color: colors.primary
            font: root.rootFont
          }

          Rectangle {
            id: trackProgressBar
            Accessible.role: Accessible.ProgressBar
            Accessible.name: "Track progress for " + (root.activePlayer.metadata["xesam:title"] || "unknown track")

            Layout.fillWidth: true
            implicitHeight: trackTimeline.implicitHeight / 4

            color: colors.primary
            radius: height / 2

            Rectangle {
              id: trackProgressBarFill

              width: root.activePlayer.length > 0 
                ? parent.width * (root.activePlayer.position / root.activePlayer.length)
                : 0
              anchors.verticalCenter: parent.verticalCenter
              implicitHeight: parent.height
              color: colors.on_primary_fixed
              radius: height / 2

              Behavior on width {
                NumberAnimation { duration: 150 }
              }
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                if (root.activePlayer.length > 0) {
                  const clickPosition = mouse.x / trackProgressBar.width;
                  root.activePlayer.position = Math.floor(clickPosition * root.activePlayer.length);
                }
              }
            }
          }

          Text {
            id: trackLength
            Accessible.role: Accessible.StaticText
            Accessible.name: "Total length of track: " + root.formatTime(root.activePlayer.length)

            text: root.formatTime(root.activePlayer.length)
            color: colors.primary
            font: root.rootFont
          }
        }

        RowLayout {
          id: trackControl
          Accessible.role: Accessible.Group
          Accessible.name: "Playback controls for " + (root.activePlayer.metadata["xesam:title"] || "unknown track")

          Repeater {
            model: [
              { 
                name: "Previous",
                icon: "󰒫",
                cmd: root.activePlayer.previous
              },
              { 
                name: "Play/Pause",
                icon: root.activePlayer.isPlaying ? "" : "",
                cmd: root.activePlayer.togglePlaying
              },
              { 
                name: "Next",
                icon: "󰒬",
                cmd: root.activePlayer.next
              }
            ]

            delegate: Rectangle {
              id: button
              required property var modelData
              Accessible.role: Accessible.Button
              Accessible.name: "Playback control: " + button.modelData.name

              implicitWidth: root.rootFont.pixelSize * 1.5
              implicitHeight: implicitWidth
              color: buttonMouseArea.pressed ? colors.on_primary : colors.primary
              radius: implicitHeight / 2

              Behavior on color {
                ColorAnimation { duration: 150 }
              }

              Text {
                anchors.centerIn: parent
                text: button.modelData.icon
                color: buttonMouseArea.pressed ? colors.primary : colors.on_primary
                font: root.rootFont

                Behavior on color {
                  ColorAnimation { duration: 150 }
                }
              }

              MouseArea {
                id: buttonMouseArea

                anchors.fill: parent
                onClicked: button.modelData.cmd && button.modelData.cmd()
              }
            }
          }
        }
      }
    }
  }

  function formatTime(seconds) {
    if (!seconds || seconds < 0) return "0:00";
    const m = Math.floor(seconds / 60);
    const s = Math.floor(seconds % 60);
    return m + ":" + (s < 10 ? "0" : "") + s;
  }
}
