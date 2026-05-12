import Quickshell.Wayland
import Quickshell
import QtQuick.Layouts
import QtQuick

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
					color: Matugen.secondary
					font.pointSize: 22
				}

				Text {
					text: "Go to Settings to activate Linux"
					color: Matugen.secondary
					font.pointSize: 14
				}
			}
		}
	}
}
