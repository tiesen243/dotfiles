pragma Singleton

import Quickshell.Services.Mpris
import Quickshell
import QtQuick

import qs.Commons

Singleton {
  id: root

  property MprisPlayer activePlayer: {
    const players = Mpris.players.values;
    if (!players || players.length === 0) return null;

    for (const player of players)
      if (player.playbackState === MprisPlaybackState.Playing) return player;
    return players[0];
  }

  property string trackTitle: root.activePlayer ? root.activePlayer.trackTitle || root.activePlayer.metadata["xesam:title"] || "Unknown Title" : ""
  property string trackArtist: root.activePlayer ? root.activePlayer.trackArtist || (root.activePlayer.metadata["xesam:artist"] ? root.activePlayer.metadata["xesam:artist"].join(", ") : "Unknown Artist") : ""
  property string trackAlbum: root.activePlayer ? root.activePlayer.trackAlbum || root.activePlayer.metadata["xesam:album"] || "Unknown Album" : ""
  property string trackArtUrl: root.activePlayer ? root.activePlayer.trackArtUrl || root.activePlayer.metadata["mpris:artUrl"] || "" : ""
  property int trackLength: root.activePlayer ? root.activePlayer.length || root.activePlayer.metadata["mpris:length"] || 0 : 0

  property var state: root.activePlayer ? root.activePlayer.playbackState : MprisPlaybackState.Stopped

  function play(): void {
    if (root.activePlayer && root.activePlayer.canPlay) root.activePlayer.togglePlaying()
  }

  function stop(): void {
    if (root.activePlayer) root.activePlayer.stop()
  }

  function pause(): void {
    if (root.activePlayer && root.activePlayer.canPause) root.activePlayer.pause()
  }

  function playNext(): void {
    if (!root.activePlayer || !root.activePlayer.canGoNext) return
    root.activePlayer.next()
  }

  function playPrevious(): void {
    if (!root.activePlayer || !root.activePlayer.canGoPrevious) return
    root.activePlayer.previous()
  }

  function seek(position) {
    if (!root.activePlayer || !root.activePlayer.canSeek) return

    positionTimer.running = false
    root.activePlayer.position = Math.floor(position)
    if (root.activePlayer.isPlaying) positionTimer.running = true
  }

  Timer {
    id: positionTimer
    interval: 1000
    repeat: true
    running: root.activePlayer !== null && root.activePlayer.isPlaying
    onTriggered: root.activePlayer.positionChanged()
  }
}
