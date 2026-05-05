import QtQuick
import Quickshell.Io

Item {
  id: battery

  implicitWidth: batteryContent.width

  property string stat: ""
  Process {
    id: batteryProc
    command: ["sh", "-c", "echo $(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n 1) $(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n 1)"]
    stdout: SplitParser {
      onRead: data => {
        var parts = data.trim().split(" ");
        if (parts.length === 0 || parts[0] === "") return;

        var level = parseInt(parts[0]);
        var status = parts.length > 1 ? parts[1] : "";

        var icon = "󰁻 "
        if (status === "Charging") icon = "󰂄 "
        else if (level == 100) icon = "󰁹 "
        else if (level >= 80) icon = "󰂁 "
        else if (level >= 60) icon = "󰁿 "
        else if (level >= 40) icon = "󰁽 "

        battery.stat = icon + level + "%";
      }
    }
    Component.onCompleted: running = true
  }

  Text {
    id: batteryContent

    anchors { right: parent.right; verticalCenter: parent.verticalCenter }
    text: battery.stat
    color: colors.primary
    font { pixelSize: bar.fontSize; family: bar.fontFamily }

    Timer {
      interval: 5000
      running: true
      repeat: true
      onTriggered: batteryProc.running = true
    }
  }
}

