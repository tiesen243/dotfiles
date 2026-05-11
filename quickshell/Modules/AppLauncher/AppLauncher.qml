pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

import "../../Services"

Scope {
  id: root

  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  IpcHandler {
    target: "appLauncher"

    function toggle(): void {
      GlobalState.isAppLauncherOpen = !GlobalState.isAppLauncherOpen
    }
  }

  ListModel {
    id: appModel
  }

  ListModel {
    id: filteredAppModel
  }

  function filterApps(query = ""): void {
    filteredAppModel.clear()
    const lowerQuery = query.toLowerCase()
    const filtered = []

    for (let i = 0; i < appModel.count; i++) {
      const item = appModel.get(i)
      if (!query || item.name.toLowerCase().includes(lowerQuery)) filtered.push(item)
    }

    if (filtered.length > 0) filteredAppModel.append(filtered)
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: appLauncherWindow
      required property var modelData
      screen: modelData
      visible: GlobalState.isAppLauncherOpen || appLauncherContent.implicitHeight > 0

      anchors.bottom: true
      implicitWidth: 1920 / 2
      implicitHeight: 1080 / 2
      color: "transparent"

      Region { id: clickCatcher }
      mask: visible ? null : clickCatcher

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
      WlrLayershell.exclusiveZone: -1
      onVisibleChanged: {
        if (!visible) return searchField.text = ""

        searchField.forceActiveFocus()
        if (appModel.count === 0) appProc.running = true
      }

      HyprlandFocusGrab {
        active: appLauncherWindow.visible
        windows: [appLauncherWindow]
        onCleared: GlobalState.isAppLauncherOpen = false
      }

      Rectangle {
        id: appLauncherContent
        Accessible.role: Accessible.Dialog
        Accessible.name: "Application Launcher"

        anchors.bottom: parent.bottom
        implicitWidth: parent.width
        implicitHeight: GlobalState.isAppLauncherOpen ? parent.height : 0
        color: Matugen.surface
        topRightRadius: 12
        topLeftRadius: 12
        clip: true

        Behavior on implicitHeight {
          NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }

        ColumnLayout {
          Accessible.role: Accessible.List
          Accessible.name: "Application List"

          anchors.fill: parent
          anchors.margins: 16
          spacing: 16

          TextField {
            id: searchField
            Accessible.role: Accessible.EditableText
            Accessible.name: "Search Applications"

            Layout.fillWidth: true
            padding: 12
            leftPadding: searchIcon.width + 24
            focus: true

            placeholderText: "Search applications..."
            font: root.rootFont
            color: Matugen.on_surface
            selectionColor: Matugen.primary
            selectedTextColor: Matugen.on_primary

            background: Rectangle {
              anchors.fill: parent
              color: Matugen.surface
              border { color: Matugen.on_secondary; width: 2 }
              radius: 8

              Text {
                id: searchIcon
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 12
                text: ""
                font: root.rootFont
                color: Matugen.on_surface
              }
            }

            onTextChanged: {
              root.filterApps(text)
              appList.currentIndex = 0
            }

            Keys.onPressed: (event) => {
              if (event.key === Qt.Key_Escape) {
                GlobalState.isAppLauncherOpen = false
                event.accepted = true
                return
              }

              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                const selectedItem = filteredAppModel.get(appList.currentIndex)
                if (selectedItem) root.launchApp(selectedItem.exec, selectedItem.terminal)

                GlobalState.isAppLauncherOpen = false
                event.accepted = true
                return
              }

              if (filteredAppModel.count === 0) return
              const isNext = event.key === Qt.Key_Down || event.key === Qt.Key_Tab || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_N)
              const isPrev = event.key === Qt.Key_Up || event.key === Qt.Key_Backtab || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier)) || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_P)

              if (isNext || isPrev) {
                event.accepted = true

                let idx = appList.currentIndex
                if (isNext) idx = Math.min(idx + 1, filteredAppModel.count - 1)
                else if (isPrev) idx = Math.max(idx - 1, 0)

                appList.currentIndex = idx
              }
            }
          }

          ListView {
            id: appList
            model: filteredAppModel
            Accessible.role: Accessible.List
            Accessible.name: "Filtered Application List"

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8

            delegate: Rectangle {
              id: appItem
              required property var modelData
              Accessible.role: Accessible.ListItem
              Accessible.name: modelData.name

              implicitWidth: searchField.width
              implicitHeight: appText.implicitHeight + 24
              color: ListView.isCurrentItem ? Matugen.surface_bright : Matugen.surface
              border { color: Matugen.on_secondary; width: 2 }
              radius: 8

              RowLayout {
                anchors { 
                  left: parent.left
                  right: parent.right
                  verticalCenter: parent.verticalCenter 
                  margins: 8
                }

                Image {
                  id: appIcon
                  visible: appItem.modelData.icon !== ""

                  source: appItem.modelData.icon
                  sourceSize: Qt.size(24, 24)
                }

                Text {
                  id: appText

                  Layout.fillWidth: true
                  text: appItem.modelData.name
                  color: appItem.ListView.isCurrentItem ? Matugen.primary : Matugen.on_surface
                  font: root.rootFont
                  elide: Text.ElideRight

                  MouseArea {
                    anchors.fill: parent
                    onClicked: {
                      root.launchApp(appItem.modelData.exec, appItem.modelData.terminal)
                      GlobalState.isAppLauncherOpen = false
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  function launchApp(exec, terminal = false): void {
    const cleanExec = exec.replace(/%[a-zA-Z]/g, "").trim()
    if (terminal) launchProc.command = ["sh", "-c", `kitty "${cleanExec}"`]
    else launchProc.command = ["sh", "-c", `hyprctl dispatch exec "${cleanExec}"`]

    launchProc.running = true
  }

  Process {
    id: appProc
    command: ["sh", "-c", "find /usr/share/applications ~/.local/share/applications -name '*.desktop' 2>/dev/null | while read -r file; do name=$(grep -m1 '^Name=' \"$file\" | cut -d= -f2-); exec=$(grep -m1 '^Exec=' \"$file\" | cut -d= -f2-); icon=$(grep -m1 '^Icon=' \"$file\" | cut -d= -f2-); terminal=$(grep -m1 '^Terminal=' \"$file\" | cut -d= -f2-); [ -n \"$name\" ] && [ -n \"$exec\" ] && echo \"$name|$exec|$icon|$terminal\"; done | sort -u"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.split("\n")
        appModel.clear()

        if (lines.length === 0 || (lines.length === 1 && lines[0] === ""))
          return root.filterApps("")

        const items = []
        const seen = new Set()

        for (const line of lines) {
          const parts = line.split("|")
          if (parts.length < 2) continue
          
          const name = parts[0].trim()
          if (seen.has(name)) continue

          const exec = parts[1].trim()
          const icon = parts[2] ? "image://icon/" + parts[2].trim() : ""
          const terminal = parts[3] ? parts[3].trim().toLowerCase() === "true" : false

          if (name && exec) items.push({ icon: icon, name: name, exec: exec, terminal: terminal })
        }

        appModel.append(items)
        root.filterApps("")
      }
    }
  }

  Process {
    id: launchProc
  }
}
