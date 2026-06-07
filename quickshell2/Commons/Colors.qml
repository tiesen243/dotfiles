pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
  id: root

  property string surface: "#181818"
  property string on_surface: "#ededed"
  property string surface_bright: "#333333"

  property string primary: "#3f5ec2"
  property string on_primary: "#eff6ff"

  property string secondary: "#222222"
  property string on_secondary: "#ebebeb"

  property string muted: "#1d1d1d"
  property string on_muted: "#a4a4a4"

  property string border: "#242424"

  FileView {
    id: colorsFile
    path: Settings.home + "/dotfiles/quickshell/colors.json"
    watchChanges: true
    onFileChanged: updateColorsProc.running = true
  }

  Process {
    id: updateColorsProc
    command: ["sh", "-c", `cat "${colorsFile.path}"`]
    stdout: StdioCollector {
      onStreamFinished: {
        const cleanedText = text.trim().replace(/,\s*([}\]])/g, '$1')
        const colors = JSON.parse(cleanedText)

        root.surface = colors.surface || root.surface
        root.on_surface = colors.on_surface || root.on_surface
        root.surface_bright = colors.surface_bright || root.surface_bright

        root.primary = colors.primary || root.primary
        root.on_primary = colors.on_primary || root.on_primary

        root.secondary = colors.secondary || root.secondary
        root.on_secondary = colors.on_secondary || root.on_secondary

        root.muted = colors.muted || root.muted
        root.on_muted = colors.on_muted || root.on_muted

        root.border = colors.border || root.border
      }
    }
    Component.onCompleted: updateColorsProc.running = true
  }
}
