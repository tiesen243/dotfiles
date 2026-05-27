import QtQuick
import QtQuick.Shapes

import "../../Services"

Item {
  id: root
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
    Accessible.name: Niri.activeToplevel ? "Active window: " + Niri.activeToplevel.title : "No active window"

    text: Niri.activeToplevel 
      ? root.truncateTitle(Niri.activeToplevel.title, 50) 
      : ""
    color: Matugen.primary
    font: root.rootFont
  }
}
