pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick

import qs.Commons
import qs.Services 

Scope {
  id: root

  property string searchQuery: ""

  IpcHandler {
    target: "clipboard-manager"
    function toggle(): void {
      GlobalState.toggleClipboard()
    }
  }

  ListModel {
    id: filteredClipModel
  }

  function filterClips(query = ""): void {
    filteredClipModel.clear()
    const lowerQuery = query.toLowerCase().trim()
    const filtered = []

    for (let i = 0; i < Clipboard.list.length; i++) {
      const item = Clipboard.list[i]
      if (!query || item.content.toLowerCase().includes(lowerQuery)) {
        filtered.push({
          clipId: item.id,
          type: item.type,
          content: item.content
        })
      }
    }

    if (filtered.length > 0) filteredClipModel.append(filtered)
  }

  Connections {
    target: Clipboard
    function onListChanged() {
      root.filterClips(root.searchQuery)
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: clipboardWindow
      required property var modelData
      screen: modelData
      visible: GlobalState.isClipboardVisible || clipboardManagerContent.implicitHeight > 0

      anchors.bottom: true
      implicitWidth: 1920 / 2
      implicitHeight: 1080 / 2
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "quickshell-clipboard-manager"
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
      WlrLayershell.exclusiveZone: -1
      
      onVisibleChanged: {
        if (!visible) return root.searchQuery = ""

        clipboardManagerContent.searchFieldFocus = true
        Clipboard.refresh() 
        root.filterClips(root.searchQuery)
      }

      ClipboardManagerContent {
        id: clipboardManagerContent
      }
    }
  }
}
