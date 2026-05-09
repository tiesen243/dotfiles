pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

import "../../Services"

Scope {
  id: root
  Colors { id: colors }
  property int currnetItem: -1

  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  IpcHandler {
    target: "clipboardManager"

    function toggle(): void {
      GlobalState.closeAllPopups('clipboard')
      GlobalState.isClipboardOpen = !GlobalState.isClipboardOpen
    }

    function clearHistory(): void {
      cliphistProc.command = ["cliphist", "wipe"]
      cliphistProc.running = true
    }
  }

  ListModel {
    id: clipboardHistory
  }

  ListModel {
    id: filteredClipboardHistory
  }

  function filterClipboardHistory(query = ""): void {
    filteredClipboardHistory.clear();
    const lowerQuery = query.toLowerCase();
    const filtered = [];

    for (let i = 0; i < clipboardHistory.count; i++) {
      const item = clipboardHistory.get(i);
      if (!query || item.text.toLowerCase().includes(lowerQuery)) filtered.push(item)
    }

    if (filtered.length > 0) filteredClipboardHistory.append(filtered)
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: clipboardManager
      required property var modelData
      screen: modelData
      visible: GlobalState.isClipboardOpen

      anchors { top: true; left: true; right: true; bottom: true }
      color: "transparent"

      WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
      onVisibleChanged: {
        if (!visible) return

        searchField.forceActiveFocus()
        cliphistProc.running = true;
      }

      Rectangle {
        anchors.fill: parent
        color: colors.surface
        opacity: 0.8

        MouseArea {
          anchors.fill: parent
          onClicked: GlobalState.isClipboardOpen = false
        }
      }

      Rectangle {
        Accessible.role: Accessible.Dialog
        Accessible.name: "Clipboard Manager"

        anchors.centerIn: parent
        implicitWidth: 1920 / 3
        implicitHeight: 1080 / 3
        color: colors.surface
        border { color: colors.on_primary; width: 2 }
        radius: 8

        ColumnLayout {
          Accessible.role: Accessible.List
          Accessible.name: "Clipboard Manager Content"

          anchors.fill: parent
          anchors.margins: 16
          spacing: 16

          TextField {
            id: searchField
            Accessible.role: Accessible.EditableText
            Accessible.name: "Search Clipboard History"

            Layout.fillWidth: true
            padding: 8
            placeholderText: "Search clipboard history..."
            font: root.rootFont
            focus: true

            background: Rectangle {
              anchors.fill: parent
              color: colors.surface_variant
              border { color: colors.on_primary; width: 2 }
              radius: 4
            }

            onTextChanged: {
              root.filterClipboardHistory(text)
              clipboardList.currentIndex = 0
            }
              


            Keys.onPressed: (event) => {
              if (event.key === Qt.Key_Escape) {
                GlobalState.isClipboardOpen = false
                event.accepted = true
                return
              }

              if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                const selectedItem = filteredClipboardHistory.get(clipboardList.currentIndex)
                if (selectedItem) {
                  const escapedText = selectedItem.text.replace(/'/g, "'\\''")
                  root.copyToClipboard(selectedItem.id, selectedItem.text)
                }

                GlobalState.isClipboardOpen = false
                event.accepted = true
                return
              }

              if (filteredClipboardHistory.count === 0) return;
              const isNext = event.key === Qt.Key_Down || event.key === Qt.Key_Tab || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_N)
              const isPrev = event.key === Qt.Key_Up || event.key === Qt.Key_Backtab || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier)) || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_P)

              if (isNext || isPrev) {
                event.accepted = true

                let idx = clipboardList.currentIndex;
                if (isNext) idx = Math.min(idx + 1, filteredClipboardHistory.count - 1)
                else if (isPrev) idx = Math.max(idx - 1, 0)

                clipboardList.currentIndex = idx
              }
            }
          }

          ListView {
            id: clipboardList
            model: filteredClipboardHistory
            Accessible.role: Accessible.List
            Accessible.name: "Filtered Clipboard History"

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8

            delegate: Rectangle {
              id: clipboardItem
              required property var modelData
              Accessible.role: Accessible.ListItem
              Accessible.name: modelData.text

              Layout.fillWidth: true
              implicitHeight: clipboardText.implicitHeight + 16
              color: ListView.isCurrentItem ? colors.primary : colors.on_secondary
              border { color: colors.on_primary; width: 2 }
              radius: 4

              Text {
                id: clipboardText

                anchors { 
                  left: parent.left
                  right: parent.right
                  verticalCenter: parent.verticalCenter 
                  margins: 8
                }
                text: clipboardItem.modelData.text
                color: clipboardItem.ListView.isCurrentItem ? colors.on_primary : colors.on_surface
                font: root.rootFont
                elide: Text.ElideRight

                MouseArea {
                  anchors.fill: parent
                  onClicked: root.copyToClipboard(clipboardItem.modelData.id, clipboardItem.modelData.text)
                }
              }
            }
          }
        }
      }
    }
  }

  function copyToClipboard(id, text) {
    const escapedText = text.replace(/'/g, "'\\''")
    setClipProc.command = ["sh", "-c", `printf "%s\t%s\n" '${id}' '${escapedText}' | cliphist decode | wl-copy`]
    setClipProc.running = true
    GlobalState.isClipboardOpen = false
  }

  Process {
    id: cliphistProc
    command: ["cliphist", "list"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        clipboardHistory.clear();

        if (lines.length === 0 || (lines.length === 1 && lines[0] === ""))
          return root.filterClipboardHistory("")

        const items = []
        for (const line of lines) {
          const tabIndex = line.indexOf("\t")
          const id = parseInt(line.substring(0, tabIndex).trim())
          const text = line.substring(tabIndex + 1).trim()
          if (!text || items.some(item => item.text === text)) continue
          items.push({ id: id, text: text })
        }

        clipboardHistory.append(items)
        root.filterClipboardHistory("")
      }
    }
  }

  Process {
    id: setClipProc
  }
}
