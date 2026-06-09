import QtQuick.Layouts
import QtQuick.Effects
import QtQuick

import qs.Commons
import qs.Services

Rectangle {
	id: root
	required property LockscreenContext context

	color: Colors.surface

  Image {
    id: backgroundImage

    anchors.fill: parent
    cache: true
    smooth: true

    source: Background.wallpaperDir
    fillMode: Image.PreserveAspectCrop
    asynchronous: true

    layer.enabled: true
    layer.effect: MultiEffect {
      blurEnabled: true
      blurMax: 32
      blur: 1.0

      brightness: -0.4
    }
  }

  ColumnLayout {
    id: content

    anchors.fill: parent
    anchors.margins: 32
    spacing: 32

    LockscreenInfo {
      id: lockscreenInfo

      Layout.fillWidth: true
    }

    LockscreenClock {
      id: lockscreenClock

      Layout.fillWidth: true
    }


    Item { Layout.fillHeight: true }

    LockscreenPlayer {
      id: lockscreenPlayer

      Layout.fillWidth: true
    }

    LockscreenInput {
      id: lockscreenInput
      context: root.context

      Layout.fillWidth: true
    }
	}
}
