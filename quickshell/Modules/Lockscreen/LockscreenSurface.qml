import QtQuick.Layouts
import QtQuick.Effects
import QtQuick
import QtCore

import qs.Colors

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

    source: root.getWallpaper("_background.png")
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

	function getWallpaper(fileName: string): string {
    return StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] + "/dotfiles/assets/" + fileName
  }
}
