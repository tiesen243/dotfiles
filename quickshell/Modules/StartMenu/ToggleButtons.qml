import Quickshell.Io

import QtQuick
import QtQuick.Layouts

import QtCore

Item {
  id: toggleButtons

  implicitHeight: toggleButtonsContainer.implicitHeight + 12

  property bool wifiEnable: true
  property bool bluetoothEnable: true
  property bool powerSavingEnable: false
  property bool dndEnable: false

  Process {
    id: wifiProc
    command: ["nmcli", "radio", "wifi"]
    stdout: SplitParser {
      onRead: data => toggleButtons.wifiEnable = (data.trim() === 'enabled')
    }
    Component.onCompleted: running = true
  }

  Process {
    id: toggleWifiProc
    command: ["nmcli", "radio", "wifi", toggleButtons.wifiEnable ? "off" : "on"]
    stdout: StdioCollector {
      onStreamFinished: wifiProc.running = true
    }
  }

  Process {
    id: bluetoothProc
    command: ["bluetoothctl", "show"]
    stdout: SplitParser {
      onRead: data => {
        if (data.includes("Powered: yes")) toggleButtons.bluetoothEnable = true
        else if (data.includes("Powered: no")) toggleButtons.bluetoothEnable = false
      }
    }
  }

  Process {
    id: toggleBluetoothProc
    command: ["bluetoothctl", "power", toggleButtons.bluetoothEnable ? "off" : "on"]
    stdout: StdioCollector {
      onStreamFinished: bluetoothProc.running = true
    }
  }

  Process {
    id: powerSavingProc
    command: ["powerprofilesctl", "get"]
    stdout: SplitParser {
      onRead: data => toggleButtons.powerSavingEnable = (data.trim() === 'power-saver')
    }
    Component.onCompleted: running = true
  }

  Process {
    id: togglePowerSavingProc
    command: ["powerprofilesctl", "set", toggleButtons.powerSavingEnable ? "balanced" : "power-saver"]
    stdout: StdioCollector {
      onStreamFinished: powerSavingProc.running = true
    }
  }

  GridLayout {
    id: toggleButtonsContainer

    anchors { top: parent.top; left: parent.left; margins: 12 }
    columnSpacing: 12
    columns: 4
    rowSpacing: 12
    rows: 1

    Repeater {
      model: [
        { icon: '', isActive: toggleButtons.wifiEnable, toggle: toggleWifiProc },
        { icon: '󰂯', isActive: toggleButtons.bluetoothEnable, toggle: toggleBluetoothProc },
        { icon: '', isActive: toggleButtons.powerSavingEnable, toggle: togglePowerSavingProc },
        { icon: '', isActive: false, toggle: null }
      ]

      Rectangle {
        color: modelData.isActive ? colors.primary_fixed : colors.on_primary_fixed
        implicitWidth: (startMenuContent.width / 4) - 16
        implicitHeight: 40
        radius: 6

        Text {
          anchors.centerIn: parent
          text: modelData.icon
          color: modelData.isActive ? colors.on_primary_fixed : colors.primary_fixed
          font { pixelSize: startMenu.fontSize }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: modelData.toggle.running = true
        }
      }
    }
  }
}
