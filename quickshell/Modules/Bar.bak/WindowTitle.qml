import Quickshell.Hyprland

import QtQuick


Text {
  function truncateText(text, maxLength) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - 1) + "…";
  }

  text: Hyprland.activeToplevel ? truncateText(Hyprland.activeToplevel.title, 50) : ""
  color: colors.primary
  font { pixelSize: bar.fontSize; family: bar.fontFamily }
}
