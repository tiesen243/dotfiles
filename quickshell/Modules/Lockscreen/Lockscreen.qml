import Quickshell.Wayland
import Quickshell.Io
import Quickshell

Scope {
  id: root

  IpcHandler {
    target: "lockscreen"

    function lock(): void {
      lock.locked = true
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
}
