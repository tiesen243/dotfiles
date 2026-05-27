pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
  id: root

  property var workspaces: []
  property var activeToplevel: null

  function switchToWorkspace(id) {
    niriSwitchProc.command = ["niri", "msg", "action", "focus-workspace", id]
    niriSwitchProc.running = true
  }

  Process {
    id: niriStreamProc
    command: ["niri", "msg", "--json", "event-stream"]
    stdout: SplitParser {
      onRead: data => {
        if (data.includes("WorkspaceActivated"))
          niriWorkspacesProc.running = true

        if (data.includes("WindowFocusChanged"))
          niriTitleProc.running = true
      }
    }
    Component.onCompleted: niriStreamProc.running = true
  }

  Process {
    id: niriWorkspacesProc
    command: ["niri", "msg", "--json", "workspaces"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        root.workspaces = JSON.parse(lines[lines.length - 1])
      }
    }
    Component.onCompleted: niriWorkspacesProc.running = true
  }

  Process {
    id: niriTitleProc
    command: ["niri", "msg", "--json", "windows"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        const windows = JSON.parse(lines[lines.length - 1])
        
        const focusedWindow = windows.find(w => w.is_focused)
        root.activeToplevel = focusedWindow || null
      }
    }
    Component.onCompleted: niriTitleProc.running = true
  }

  Process {
    id: niriSwitchProc
  }
}
