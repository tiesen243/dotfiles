import QtQuick
import Quickshell

ShellRoot {
	LockscreenContext {
		id: lockContext
		onUnlocked: Qt.quit();
	}

	FloatingWindow {
		LockscreenSurface {
			anchors.fill: parent
			context: lockContext
		}
	}

	Connections {
		target: Quickshell

		function onLastWindowClosed() {
			Qt.quit();
		}
	}
}
