pragma ComponentBehavior: Bound

import Quickshell.Io
import QtQuick.Layouts
import QtQuick

import qs.Commons

Item {
  id: root

  property bool isOpen: GlobalState.isControlCenterVisible

  implicitWidth: buttons.implicitWidth
  implicitHeight: buttons.implicitHeight

  GridLayout {
    id: buttons
    rows: 2
    rowSpacing: Settings.style.margin
    columns: 4
    columnSpacing: Settings.style.margin

    Repeater {
      model: items

      delegate: Rectangle {
        id: button
        required property var modelData
        Accessible.role: Accessible.Button
        Accessible.name: modelData.name + (buttonMouseArea.containsMouse ? ", hover" : "") + (modelData.isChecked ? ", checked" : "")

        implicitWidth: ((1920 / 4) - Settings.style.margin * 5) / 4
        implicitHeight: 42
        color: button.modelData.isChecked ? Colors.primary : Colors.on_primary
        radius: Settings.style.radius

        Text {
          id: buttonLabel
          Accessible.role: Accessible.StaticText
          Accessible.name: button.modelData.name

          anchors.centerIn: parent
          text: button.modelData.icon
          color: button.modelData.isChecked ? Colors.on_primary : Colors.primary
          font: Settings.getFont()
        }

        MouseArea {
          id: buttonMouseArea
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (button.modelData.setCmd === "") return

            if (root.actions[button.modelData.setCmd])
              root.actions[button.modelData.setCmd]()
            else buttonSetProc.running = true

            if (button.modelData.getCmd !== "") 
              items.setProperty(button.modelData.index, "isChecked", !button.modelData.isChecked) 
          }
        }

        Shortcut {
          sequence: button.modelData.shortcut
          onActivated: {
            if (button.modelData.setCmd === "") return
            buttonMouseArea.clicked(null)
          }
        }

        Process {
          id: buttonGetProc
          command: button.modelData.getCmd ? ["sh", "-c", button.modelData.getCmd] : [];
          stdout: SplitParser {
            onRead: data => 
              items.setProperty(button.modelData.index, "isChecked", data.trim() === "true")
          }
          Component.onCompleted: {
            if (command.length > 0) running = true
          }
        }

        Connections {
          target: root
          function onIsOpenChanged() {
            if (GlobalState.isControlCenterVisible && button.modelData.getCmd !== "")
              buttonGetProc.running = true
          }
        }

        Process {
          id: buttonSetProc
          command: button.modelData.setCmd && root.actions[button.modelData.setCmd] === undefined
            ? ["sh", "-c", button.modelData.setCmd] : [];
        }
      }
    }
  }

  ListModel {
    id: items
    ListElement { 
      icon: ""; 
      name: "Wi-Fi"; 
      isChecked: false;
      getCmd: "nmcli radio wifi | grep -qw enabled && echo true || echo false";
      setCmd: "nmcli radio wifi | grep -qw enabled && nmcli radio wifi off || nmcli radio wifi on";
      shortcut: "w";
    }
    ListElement { 
      icon: ""; 
      name: "Bluetooth"; 
      isChecked: false;
      getCmd: "bluetoothctl show | grep -q 'Powered: yes' && echo true || echo false";
      setCmd: "bluetoothctl show | grep -q 'Powered: yes' && bluetoothctl power off || bluetoothctl power on";
      shortcut: "b";
    }
    ListElement { 
      icon: ""; 
      name: "Power Saving"; 
      isChecked: false;
      getCmd: "[ \"$(powerprofilesctl get)\" = \"power-saver\" ] && echo true || echo false";
      setCmd: "[ \"$(powerprofilesctl get)\" = \"power-saver\" ] && powerprofilesctl set balanced || powerprofilesctl set power-saver";
      shortcut: "p";
    }
    ListElement { 
      icon: "󰂛"; 
      name: "Do Not Disturb"; 
      isChecked: false;
      getCmd: "quickshell ipc call notifications is_dnd";
      setCmd: "quickshell ipc call notifications toggle_dnd";
      shortcut: "d";
    }
    ListElement { 
      icon: ""; 
      name: "Airplane Mode"; 
      isChecked: false;
      getCmd: "rfkill list all | grep -q 'Soft blocked: no' && echo false || echo true";
      setCmd: "rfkill list all | grep -q 'Soft blocked: no' && rfkill block all || rfkill unblock all";
      shortcut: "a";
    }
    ListElement { 
      icon: ""; 
      name: "File Explorer"; 
      isChecked: false;
      getCmd: "";
      setCmd: "thunar";
      shortcut: "";
    }
    ListElement { 
      icon: ""; 
      name: "Browser"; 
      isChecked: false;
      getCmd: "";
      setCmd: "zen-browser";
      shortcut: "";
    }
    ListElement { 
      icon: "󰸉"; 
      name: "Wallpaper"; 
      isChecked: false;
      getCmd: "";
      setCmd: "toggle-wallpaper-selector";
      shortcut: "";
    }
  }

  property var actions: ({
    'toggle-wallpaper-selector': () => {
    }
  })
}
