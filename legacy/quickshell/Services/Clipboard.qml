pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property var list: []

  Process {
    id: cliphistProc
    
    command: [
      "bash", "-c", 
      "mkdir -p /tmp/cliphist_previews && " +
      "cliphist list | head -n 50 | while read -r line; do " +
      "  id=$(echo \"$line\" | cut -f1); " +
      "  content=$(echo \"$line\" | cut -f2-); " +
      "  if [[ \"$content\" == *\"[[ binary data\"* ]]; then " +
      "    if [ ! -f \"/tmp/cliphist_previews/${id}.png\" ]; then " +
      "      cliphist decode \"$id\" > \"/tmp/cliphist_previews/${id}.png\" 2>/dev/null || true; " +
      "    fi; " +
      "    echo \"$id|IMAGE|/tmp/cliphist_previews/${id}.png\"; " +
      "  else " +
      "    echo \"$id|TEXT|$content\"; " +
      "  fi; " +
      "done"
    ]
    running: false

    stdout: StdioCollector {
      onStreamFinished: {
        if (!text) return root.list = []

        const lines = text.trim().split("\n")
        const parsedItems = []

        for (let i = 0; i < lines.length; i++) {
          const line = lines[i].trim()
          if (line === "") continue

          const parts = line.split("|")
          if (parts.length < 3) continue

          parsedItems.push({
            "id": parts[0],
            "type": parts[1],
            "content": parts[2]
          });
        }

        root.list = parsedItems
      }
    }
  }

  Process { id: execProc }

  function refresh() {
    cliphistProc.running = true
  }

  function selectItem(id) {
    execProc.command = ["bash", "-c", `cliphist decode ${id} | wl-copy`]
    execProc.running = true
  }

  function deleteItem(id) {
    execProc.command = ["bash", "-c", `cliphist decode ${id} | cliphist delete && rm -f /tmp/cliphist_previews/${id}.png`]
    execProc.running = true
    execProc.onFinished = () => { root.refresh() }
  }
}
