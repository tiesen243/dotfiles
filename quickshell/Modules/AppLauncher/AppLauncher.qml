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
    target: "app-launcher"
    function toggle(): void {
      GlobalState.toggleAppLauncher()
    }
  }

  ListModel {
    id: filteredAppModel
  }

  function filterApps(query = ""): void {
    filteredAppModel.clear()
    const lowerQuery = query.toLowerCase().trim()
    const filtered = []

    for (let i = 0; i < Apps.list.length; i++) {
      const item = Apps.list[i]
      if (!query || item.name.toLowerCase().includes(lowerQuery)) {
        filtered.push({
          name: item.name,
          exec: item.exec,
          icon: item.icon ? "image://icon/" + item.icon : "",
          terminal: item.terminal
        })
      }
    }

    if (filtered.length > 0) {
      filteredAppModel.append(filtered)
    }
  }

  Connections {
    target: Apps
    function onListChanged() {
      root.filterApps(root.searchQuery)
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: appLauncherWindow
      required property var modelData
      screen: modelData
      visible: GlobalState.isAppLauncherVisible || appLauncherContent.implicitHeight > 0

      anchors.bottom: true
      implicitWidth: 1920 / 2
      implicitHeight: 1080 / 2
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
      WlrLayershell.exclusiveZone: -1
      
      onVisibleChanged: {
        if (!visible) return root.searchQuery = ""

        appLauncherContent.searchFieldFocus = true
        Apps.refresh() 
        root.filterApps(root.searchQuery)
      }

      AppLauncherContent {
        id: appLauncherContent
      }
    }
  }
}
