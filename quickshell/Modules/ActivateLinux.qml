import Quickshell.Wayland
import Quickshell
import QtQuick.Layouts
import QtQuick

import "../Services"

Scope {
  id: root

	Variants {
		model: Quickshell.screens

		PanelWindow {
			id: activateLinux
			property var modelData
			screen: modelData

			anchors { right: true; bottom: true }
			margins { right: 50; bottom: 50 }

			implicitWidth: content.width
			implicitHeight: content.height
			color: "transparent"
			mask: Region {}

			WlrLayershell.layer: WlrLayer.Overlay

			ColumnLayout {
				id: content

				Text {
					text: "Activate Linux"
					color: Matugen.surface_bright
					font.pointSize: 22
				}

				Text {
					text: "Go to Settings to activate Linux"
					color: Matugen.surface_bright
					font.pointSize: 14
				}
			}
		}
	}
}
