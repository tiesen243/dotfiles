pragma Singleton

import Quickshell.Services.Notifications
import Quickshell
import QtQuick

Singleton {
  id: root

  property list<var> notifications: []
  property list<var> notificationHistory: []

  property int _seqCounter: 0
  property int count: notifications.length
  property bool isDoNotDisturb: false

  Component {
    id: notificationEntity
    NotificationEntity {}
  }

  NotificationServer {
    id: notificationServer

    actionsSupported:    true
    bodySupported:       true
    bodyMarkupSupported: true
    imageSupported:      true
    keepOnReload:        false

    onNotification: notification => {
      if (!notification.appName && !notification.summary
        && !notification.body && !notification.image) return

      notification.tracked = true
      const idStr = String(notification.id || "")
      if (idStr !== "") {
        const existing = root.notifications.find(n => n.notificationId === idStr)
        if (existing && !existing.closed) {
          existing.closed = true
          root.notifications = root.notifications.filter(n => n !== existing)
          existing.destroy()
        }
      }

      const entity = notificationEntity.createObject(root, {
        notification: notification,
        seqId: String(root._seqCounter++)
      })

      root.notificationHistory = [entity, ...root.notificationHistory]
      if (!root.isDoNotDisturb) {
        root.notifications = [entity, ...root.notifications]
        if (root.notifications.length > 5)
          root.notifications[root.notifications.length - 1].dismiss()
      }
    }
  }

  function _remove(notification): void {
    root.notifications = root.notifications.filter(n => n !== notification)
  }

  function dismiss(notification): void {
    if (notification) notification.dismiss()
  }

  function clear(notification): void {
    root.notificationHistory = root.notificationHistory.filter(n => n !== notification)
    root.notifications = root.notifications.filter(n => n !== notification)
    if (notification) {
      try { notification.dismiss() } catch(e) {}
      notification.destroy()
    }
  }

  function clearAll(): void {
    const removed = [...root.notificationHistory]

    root.notificationHistory = []
    root.notifications = []

    removed.forEach(n => {
      if (!n.notification) return
      
      try { n.notification.dismiss() } catch(e) {}
      n.destroy()
    })
  }
}
