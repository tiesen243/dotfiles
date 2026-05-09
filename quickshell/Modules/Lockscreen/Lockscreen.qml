pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick

Scope {
  id: root

  IpcHandler {
    target: "lockscreen"

    function lock(): void {
      lockTimer.running = true
    }
  }


	LockscreenContext {
		id: lockContext
		onUnlocked: lock.locked = false
	}

	WlSessionLock {
		id: lock
		locked: false

		WlSessionLockSurface {
			LockscreenSurface {
				anchors.fill: parent
				context: lockContext
			}
		}
	}

	Timer {
	  id: lockTimer
	  interval: 200
	  onTriggered: lock.locked = true
	}
}
