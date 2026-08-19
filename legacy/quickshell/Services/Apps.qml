pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property var list: []

  Process {
    id: appsProc
    
    command: [
      "bash", "-c", 
      "find ~/.local/share/applications /usr/share/applications -name '*.desktop' -exec awk '" +
      "BEGIN {name=\"\"; exec=\"\"; icon=\"\"; term=\"false\"; type=\"\"; nodisp=\"false\"; is_de=0}" +
      "/^\\[Desktop Entry\\]$/ {is_de=1; next}" +
      "/^\\[/ && !/^\\[Desktop Entry\\]$/ {is_de=0}" +
      "is_de && /^Name=/ {sub(/^Name=/, \"\"); name=$0}" +
      "is_de && /^Exec=/ {sub(/^Exec=/, \"\"); exec=$0}" +
      "is_de && /^Icon=/ {sub(/^Icon=/, \"\"); icon=$0}" +
      "is_de && /^Terminal=/ {sub(/^Terminal=/, \"\"); term=$0}" +
      "is_de && /^Type=/ {sub(/^Type=/, \"\"); type=$0}" +
      "is_de && /^NoDisplay=/ {sub(/^NoDisplay=/, \"\"); nodisp=$0}" +
      "END {if (type==\"Application\" && nodisp!=\"true\") print name \"|\" exec \"|\" icon \"|\" term}" +
      "' {} \\;"
    ]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        if (!text) return;

        const lines = text.trim().split("\n")
        const parsedApps = []
        const seenExecs = new Set()

        for (let i = 0; i < lines.length; i++) {
          const line = lines[i].trim()
          if (line === "") continue

          const parts = line.split("|")
          if (parts.length < 4) continue

          const name = parts[0]
          const exec = parts[1]
          const icon = parts[2]
          const terminal = parts[3].toLowerCase() === "true"

          if (name && exec && !seenExecs.has(exec)) {
            seenExecs.add(exec)
            parsedApps.push({
              "name": name,
              "exec": exec,
              "icon": icon,
              "terminal": terminal
            })
          }
        }

        parsedApps.sort((a, b) => a.name.localeCompare(b.name))
        root.list = parsedApps
      }
    }
  }

  function refresh() {
    appsProc.running = true
  }

  function launch(exec, terminal = false): void {
    const cleanExec = exec.replace(/%[a-zA-Z]/g, "").trim()

    if (terminal) launchProc.command = ["sh", "-c", `kitty -e ${cleanExec}`]
    else launchProc.command = ["sh", "-c", cleanExec]
    launchProc.running = true
  }

  Process {
    id: launchProc
  }
}
