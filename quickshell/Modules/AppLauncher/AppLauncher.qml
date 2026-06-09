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
  property string searchMode: "app" 

  IpcHandler {
    target: "app-launcher"
    function toggle(): void {
      GlobalState.toggleAppLauncher()
    }
  }

  ListModel {
    id: searchResultModel
  }

  function filterApps(query = ""): void {
    searchResultModel.clear()
    const trimmed = query.trim()

    if (trimmed.startsWith("?")) {
      searchMode = "web"
      processWebSearch(trimmed.substring(1).trim())
    } else if (trimmed.startsWith("=")) {
      searchMode = "calc"
      processCalc(trimmed.substring(1).trim())
    } else {
      searchMode = "app"
      processAppSearch(trimmed)
    }
  }

  function processAppSearch(query): void {
    const lowerQuery = query.toLowerCase()
    const filtered = []

    for (let i = 0; i < Apps.list.length; i++) {
      const item = Apps.list[i]
      if (!query || item.name.toLowerCase().includes(lowerQuery)) {
        filtered.push({
          type: "app",
          name: item.name,
          details: item.exec,
          icon: item.icon ? "image://icon/" + item.icon : "application-x-executable",
          terminal: item.terminal
        })
      }
    }

    if (filtered.length > 0) searchResultModel.append(filtered)
  }

  function processWebSearch(query): void {
    if (!query) return
    
    searchResultModel.append({
      type: "web",
      name: "Search Google for: \"" + query + "\"",
      details: "https://www.google.com/search?q=" + encodeURIComponent(query),
      icon: "image://icon/web-browser",
      terminal: false
    })
  }

  function processCalc(query): void {
    if (!query) return
    
    try {
      const sanitized = query.replace(/[^0-9\+\-\*\/\(\)\.\s]/g, '')
      if (sanitized.length === 0) return

      const result = Function('"use strict"; return (' + sanitized + ')')()
      
      if (result !== undefined && !isNaN(result)) {
        searchResultModel.append({
          type: "calc",
          name: "= " + result,
          details: result.toString(),
          icon: "image://icon/accessories-calculator",
          terminal: false
        })
      }
    } catch (e) {
      searchResultModel.append({
        type: "calc_error",
        name: "Invalid expression",
        details: "",
        icon: "image://icon/accessories-calculator",
        terminal: false
      })
    }
  }

  function executeResult(item): void {
    if (!item) return

    if (item.type === "app") Apps.launch(item.details, item.terminal)
    else if (item.type === "web") Apps.launch("xdg-open '" + item.details + "'", false)
    else if (item.type === "calc") Apps.launch("wl-copy '" + item.details + "'", false)

    GlobalState.toggleAppLauncher()
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
