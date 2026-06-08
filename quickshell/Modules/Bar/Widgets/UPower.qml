import Quickshell.Services.UPower
import QtQuick

import qs.Commons

Item {
  id: root

  property var upower: UPower
  implicitWidth: upowerLabel.implicitWidth
  implicitHeight: upowerLabel.implicitHeight

  Text {
    id: upowerLabel
    Accessible.role: Accessible.StaticText
    Accessible.name: "Battery level: " +
    (root.upower.displayDevice.percentage * 100) +
    (root.upower.displayDevice.state === UPowerDeviceState.Charging ? ", charging" : ", discharging")

    text: {
      const batteryLevel = Math.round(root.upower.displayDevice.percentage * 100)
      var icon = "󰁺 "

      if (root.upower.displayDevice.state === UPowerDeviceState.Charging) icon = "󰂄 "
      else if (batteryLevel >= 90) icon = "󰁹 "
      else if (batteryLevel >= 80) icon = "󰂂 "
      else if (batteryLevel >= 70) icon = "󰂁 "
      else if (batteryLevel >= 60) icon = "󰂀 "
      else if (batteryLevel >= 50) icon = "󰁿 "
      else if (batteryLevel >= 40) icon = "󰁾 "
      else if (batteryLevel >= 30) icon = "󰁽 "
      else if (batteryLevel >= 20) icon = "󰁼 "
      else if (batteryLevel >= 10) icon = "󰁻 "

      return icon + batteryLevel + "%"
    }
    color: Colors.on_surface
    font: Settings.getFont()
  }
}
