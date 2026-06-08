pragma Singleton

import Quickshell

Singleton {
  id: root

  function truncateText(text, maxLength) {
    if (text.length <= maxLength) return text
    return text.substring(0, maxLength - 1) + "…"
  }

  function formatTime(seconds) {
    if (!seconds || seconds < 0) return "00:00";
    const m = Math.floor(seconds / 60);
    const s = Math.floor(seconds % 60);
    return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
  }
}
