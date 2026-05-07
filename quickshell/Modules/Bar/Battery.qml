import Quickshell.Services.UPower
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitWidth: battery.implicitWidth
  implicitHeight: battery.implicitHeight

  property var upower: UPower

  Text {
    id: battery
    Accessible.role: Accessible.StaticText
    Accessible.name: "Battery level: " + root.level + (root.isCharging ? ", charging" : ", discharging")

    text: {
      const batteryLevel = upower.displayDevice.percentage * 100
      var icon = "󰁺 "

      if (upower.displayDevice.state === UPowerDeviceState.Charging) icon = "󰂄 "
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
    color: colors.primary
    font: root.rootFont
  }
}
