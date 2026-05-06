import Quickshell
import Quickshell.Hyprland

import qs.Colors
import qs.Modules.StartMenu

Scope {
  id: bar

  property string fontFamily: "GeistMono Nerd Font"
  property int fontSize: 14
  Colors { id: colors }



  PanelWindow {
    id: panel

    anchors { top: true; left: true; right: true }
    implicitHeight: 24
    color: colors.background
    HyprlandWindow.opacity: 0.8

    StartMenu {
      id: startMenu
      anchor: panel

      fontSize: bar.fontSize * 1.5
      fontFamily: bar.fontFamily
    }

    WorkspaceSwitcher {
      id: workspaceSwitcher
      anchors { 
        left: startMenu.right; 
        verticalCenter: parent.verticalCenter; 
        margins: 12 
      }
    }

    WindowTitle {
      id: windowTitle
      anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
      }
    }

    WiFi {
      id: wifi
      anchors { 
        right: clock.left; 
        verticalCenter: parent.verticalCenter; 
        margins: 12 
      }
    }

    // Clock
    Clock {
      id: clock
      anchors { 
        right: battery.left; 
        verticalCenter: parent.verticalCenter; 
        margins: 12 
      }
    }

    // Battery
    Battery {
      id: battery
      anchors { 
        right: parent.right; 
        verticalCenter: parent.verticalCenter; 
        margins: 8
      }
    }
  }
}
