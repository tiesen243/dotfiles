import QtQuick.Layouts
import QtQuick.Effects
import QtQuick

import "../../Services"

Rectangle {
	id: root
	Colors { id: colors }
	required property LockscreenContext context

	color: colors.surface
  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })


  Image {
    id: backgroundImage

    anchors.fill: parent
    cache: true
    smooth: true

    source: GlobalState.dotfiles + "/assets/_background.png"
    fillMode: Image.PreserveAspectCrop

    layer.enabled: true
    layer.effect: MultiEffect {
      blurEnabled: true
      blurMax: 32
      blur: 1.0
    }
  }

  ColumnLayout {
    id: content

    anchors.fill: parent
    anchors.margins: 32
    spacing: 32

    LockscreenInfo {
      id: lockscreenInfo
      rootFont: root.rootFont

      Layout.fillWidth: true
    }

    LockscreenClock {
      id: lockscreenClock
      rootFont: root.rootFont

      Layout.fillWidth: true
    }


    Item { Layout.fillHeight: true }

    LockscreenPlayer {
      id: lockscreenPlayer
      rootFont: root.rootFont

      Layout.fillWidth: true
    }

    LockscreenInput {
      id: lockscreenInput
      rootFont: root.rootFont
      context: root.context

      Layout.fillWidth: true
    }
	}
}
