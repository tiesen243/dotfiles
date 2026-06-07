pragma Singleton

import Quickshell

Singleton {
  id: root

  function truncateText(text, maxLength) {
    if (text.length <= maxLength) return text
    return text.substring(0, maxLength - 1) + "…"
  }
}

