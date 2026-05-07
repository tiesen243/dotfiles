import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

import qs.Colors

Scope {
  id: root
  Colors { id: colors }
  property bool isOpen: false

  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  IpcHandler {
    target: "appLauncher"

    function toggle(): void {
      root.isOpen = !root.isOpen
    }
  }

  ListModel {
    id: appModel
  }

  ListModel {
    id: filteredAppModel
  }

  function filterApps(query = ""): void {
    filteredAppModel.clear();
    const lowerQuery = query.toLowerCase();
    const filtered = [];

    for (let i = 0; i < appModel.count; i++) {
      const item = appModel.get(i);
      if (!query || item.name.toLowerCase().includes(lowerQuery)) filtered.push(item)
    }

    if (filtered.length > 0) filteredAppModel.append(filtered)

    appList.currentIndex = 0;
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: appLauncherWindow
      required property var modelData
      screen: modelData
      visible: root.isOpen

      anchors { top: true; left: true; right: true; bottom: true }
      color: "transparent"

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
      onVisibleChanged: {
        if (!visible) {
            searchField.text = ""
            return
        }

        searchField.forceActiveFocus()
        if (appModel.count === 0) {
            appProc.running = true;
        }
      }

      Rectangle {
        anchors.fill: parent
        color: colors.surface
        opacity: 0.8

        MouseArea {
          anchors.fill: parent
          onClicked: root.isOpen = false
        }
      }

      Rectangle {
        anchors.centerIn: parent
        implicitWidth: 1920 / 3
        implicitHeight: 1080 / 3
        color: colors.surface
        border { color: colors.on_primary; width: 2 }
        radius: 8

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 16
          spacing: 16

          TextField {
            id: searchField

            Layout.fillWidth: true
            padding: 8
            placeholderText: "Search applications..."
            font: root.rootFont
            focus: true

            background: Rectangle {
              anchors.fill: parent
              color: colors.surface_variant
              border { color: colors.on_primary; width: 2 }
              radius: 4
            }

            onTextChanged: filterApps(text)

            Keys.onPressed: (event) => {
              if (event.key === Qt.Key_Escape) {
                root.isOpen = false
                event.accepted = true
                return
              }

              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                const selectedItem = filteredAppModel.get(appList.currentIndex)
                if (selectedItem) {
                  // Execute the application, removing any %U, %F, etc. from the Exec line
                  const cleanExec = selectedItem.exec.replace(/%[a-zA-Z]/g, "").trim()
                  launchProc.command = ["sh", "-c", `hyprctl dispatch exec "${cleanExec}"`]
                  launchProc.running = true
                }

                root.isOpen = false
                event.accepted = true
                return
              }

              if (filteredAppModel.count === 0) return;
              const isNext = event.key === Qt.Key_Down || event.key === Qt.Key_Tab || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_N)
              const isPrev = event.key === Qt.Key_Up || event.key === Qt.Key_Backtab || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier)) || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_P)

              if (isNext || isPrev) {
                event.accepted = true

                let idx = appList.currentIndex;
                if (isNext) idx = Math.min(idx + 1, filteredAppModel.count - 1)
                else if (isPrev) idx = Math.max(idx - 1, 0)

                appList.currentIndex = idx
              }
            }
          }

          ListView {
            id: appList
            model: filteredAppModel

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8

            delegate: Rectangle {
              id: appItem
              required property var modelData

              implicitWidth: parent.width
              implicitHeight: appText.implicitHeight + 16
              color: ListView.isCurrentItem ? colors.primary : colors.on_secondary
              border { color: colors.on_primary; width: 2 }
              radius: 4

              RowLayout {
                anchors { 
                  left: parent.left
                  right: parent.right
                  verticalCenter: parent.verticalCenter 
                  margins: 8
                }

                Image {
                  id: appIcon
                  visible: modelData.icon !== ""

                  source: modelData.icon
                  sourceSize: Qt.size(24, 24)
                }

                Text {
                  id: appText

                  Layout.fillWidth: true
                  text: appItem.modelData.name
                  color: appItem.ListView.isCurrentItem ? colors.on_primary : colors.on_surface
                  font: root.rootFont
                  elide: Text.ElideRight
                }
              }
            }
          }
        }
      }
    }
  }

  Process {
    id: appProc
    // command: ["sh", "-c", "find /usr/share/applications ~/.local/share/applications -name '*.desktop' 2>/dev/null | while read -r file; do name=$(grep -m1 '^Name=' \"$file\" | cut -d= -f2-); exec=$(grep -m1 '^Exec=' \"$file\" | cut -d= -f2-); [ -n \"$name\" ] && [ -n \"$exec\" ] && echo \"$name|$exec\"; done | sort -u"]
    command: ["sh", "-c", "find /usr/share/applications ~/.local/share/applications -name '*.desktop' 2>/dev/null | while read -r file; do name=$(grep -m1 '^Name=' \"$file\" | cut -d= -f2-); exec=$(grep -m1 '^Exec=' \"$file\" | cut -d= -f2-); icon=$(grep -m1 '^Icon=' \"$file\" | cut -d= -f2-); [ -n \"$name\" ] && [ -n \"$exec\" ] && echo \"$name|$exec|$icon\"; done | sort -u"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        appModel.clear();

        if (lines.length === 0 || (lines.length === 1 && lines[0] === ""))
          return filterApps("")

        const items = []
        for (const line of lines) {
          const parts = line.split("|");
          if (parts.length < 2) continue;
          
          const name = parts[0].trim();
          const exec = parts[1].trim();
          const icon = parts[2] ? "image://icon/" + parts[2].trim() : "";
          
          if (name && exec) items.push({ icon: icon, name: name, exec: exec })
        }

        appModel.append(items)
        filterApps("")
      }
    }
  }

  Process {
    id: launchProc
  }
}
