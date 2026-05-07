pragma ComponentBehavior: Bound

import Quickshell.Io
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitHeight: buttons.implicitHeight

  ListModel {
    id: items
    ListElement { 
      icon: ""; 
      name: "Wi-Fi"; 
      isChecked: false;
      getCmd: "nmcli radio wifi | grep -qw enabled && echo true || echo false";
      setCmd: "nmcli radio wifi | grep -qw enabled && nmcli radio wifi off || nmcli radio wifi on";
    }
    ListElement { 
      icon: ""; 
      name: "Bluetooth"; 
      isChecked: false;
      getCmd: "bluetoothctl show | grep -q 'Powered: yes' && echo true || echo false";
      setCmd: "bluetoothctl show | grep -q 'Powered: yes' && bluetoothctl power off || bluetoothctl power on";
    }
    ListElement { 
      icon: ""; 
      name: "Power Saving"; 
      isChecked: false;
      getCmd: "[ \"$(powerprofilesctl get)\" = \"power-saver\" ] && echo true || echo false";
      setCmd: "[ \"$(powerprofilesctl get)\" = \"power-saver\" ] && powerprofilesctl set balanced || powerprofilesctl set power-saver";
    }
    ListElement { 
      icon: "󰂛"; 
      name: "Do Not Disturb"; 
      isChecked: false;
      getCmd: "";
      setCmd: "";
    }
    ListElement { 
      icon: ""; 
      name: "Airplane Mode"; 
      isChecked: false;
      getCmd: "rfkill list all | grep -q 'Soft blocked: no' && echo false || echo true";
      setCmd: "rfkill list all | grep -q 'Soft blocked: no' && rfkill block all || rfkill unblock all";
    }
    ListElement { 
      icon: ""; 
      name: "Terminal"; 
      isChecked: false;
      getCmd: "";
      setCmd: "kitty";
    }
    ListElement { 
      icon: ""; 
      name: "File Explorer"; 
      isChecked: false;
      getCmd: "";
      setCmd: "thunar";
    }
    ListElement { 
      icon: ""; 
      name: "Browser"; 
      isChecked: false;
      getCmd: "";
      setCmd: "zen-browser";
    }
  }
  
  GridLayout {
    id: buttons
    Accessible.role: Accessible.Pane
    Accessible.name: "Action Buttons Grid"

    anchors.fill: parent
    columnSpacing: 12
    columns: 4
    rowSpacing: 12
    rows: 2

    Repeater {
      model: items

      delegate: Rectangle {
        id: button
        required property var modelData
        Accessible.role: Accessible.Button
        Accessible.name: "Toggle" + modelData.name

        Layout.fillWidth: true
        implicitHeight: 40
        color: modelData.isChecked ? colors.primary : colors.on_primary
        radius: 8

        Text {
          id: buttonContent
          Accessible.role: Accessible.StaticText
          Accessible.name: button.modelData.name + " Icon"

          anchors.centerIn: parent
          text: button.modelData.icon
          color: button.modelData.isChecked ? colors.on_primary : colors.primary
          font: root.rootFont
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            if (button.modelData.setCmd === "") return
              
            buttonSetProc.running = true
            if (button.modelData.getCmd !== "") 
              items.setProperty(button.modelData.index, "isChecked", !button.modelData.isChecked)
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
            if (GlobalState.isStartMenuOpen && button.modelData.getCmd !== "")
              buttonGetProc.running = true
          }
        }

        Process {
          id: buttonSetProc
          command: button.modelData.setCmd ? ["sh", "-c", button.modelData.setCmd] : [];
        }
      }
    }
  }
}
