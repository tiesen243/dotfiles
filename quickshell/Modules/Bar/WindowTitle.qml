import Quickshell.Hyprland
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitWidth: title.implicitWidth
  implicitHeight: title.implicitHeight

  function truncateTitle(title, maxLength) {
    if (title.length <= maxLength) return title
    return title.substring(0, maxLength - 1) + "…"
  }

  Text {
    id: title
    Accessible.role: Accessible.StaticText
    Accessible.name: Hyprland.activeToplevel ? "Active window: " + Hyprland.activeToplevel.title : "No active window"

    text: Hyprland.activeToplevel 
      ? root.truncateTitle(Hyprland.activeToplevel.title, 50) 
      : ""
    color: colors.primary
    font: root.rootFont
  }
}
