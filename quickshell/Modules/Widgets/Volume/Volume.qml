import Quickshell
import Quickshell.Services.Pipewire

import QtQuick

Item {
  id: volume

  property var defaultAudioSink: Pipewire.defaultAudioSink
  property int value: defaultAudioSink && defaultAudioSink.audio
    ? Math.round(defaultAudioSink.audio.volume * 100)
    : 0
  property bool isMuted: defaultAudioSink && defaultAudioSink.audio
    ? defaultAudioSink.audio.muted
    : false

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Rectangle {
    id: volumeContainer

    anchors.fill: parent
    color: "transparent"

    Text {
      id: volumeContent

      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter

      text: (volume.isMuted ? "󰖁 " : "󰕾 ") + volume.value
      color: colors.primary

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        onWheel: mouse => {
          if (!volume.defaultAudioSink && !volume.defaultAudioSink.audio)
            return

          var step = mouse.angleDelta.y > 0 ? 0.05 : -0.05
          volume.defaultAudioSink.audio.volume = Math.max(0.0, Math.min(1.0, volume.defaultAudioSink.audio.volume + step));
          volumeContent.text = (volume.isMuted ? "󰖁 " : "󰕾 ") + volume.value
        }
        onClicked: function() {
          if (!volume.defaultAudioSink && !volume.defaultAudioSink.audio) 
            return

          volume.defaultAudioSink.audio.muted = !volume.defaultAudioSink.audio.muted
          volumeContent.text = (volume.isMuted ? "󰖁 " : "󰕾 ") + volume.value
        }
      }
    }
  }
}

