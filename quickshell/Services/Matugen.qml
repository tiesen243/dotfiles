pragma Singleton

import Quickshell.Io
import Quickshell

Singleton {
  id: root

  property string surface: "#181818"
  property string surface_bright: "#1d1d1d"
  property string on_surface: "#ededed"

  property string primary: "#3f5ec2"
  property string on_primary: "#2a3e7c"

  property string secondary: "#222222"
  property string on_secondary: "#1a1a1a"

  property string error: "#df2225"
  property string on_error: "#a71b1e"

  FileView {
    id: matugenColors
    path: GlobalState.dotfiles + "/quickshell/colors.json"
    watchChanges: true
    onFileChanged: updateColorsProc.running = true
  }

  Process {
    id: updateColorsProc
    command: ["sh", "-c", `cat "${matugenColors.path}"`]
    stdout: StdioCollector {
      onStreamFinished: {
        const cleanedText = text.trim().replace(/,\s*([}\]])/g, '$1')
        const colors = JSON.parse(cleanedText)

        root.surface = colors.surface || root.surface
        root.surface_bright = colors.surface_bright || root.surface_bright
        root.on_surface = colors.on_surface || root.on_surface

        root.primary = colors.primary || root.primary
        root.on_primary = colors.on_primary || root.on_primary

        root.secondary = colors.secondary || root.secondary
        root.on_secondary = colors.on_secondary || root.on_secondary

        root.error = colors.error || root.error
        root.on_error = colors.on_error || root.on_error
      }
    }
  }
}
