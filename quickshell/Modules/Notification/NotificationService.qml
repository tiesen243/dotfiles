pragma Singleton

import Quickshell.Services.Notifications
import Quickshell
import QtQuick

Singleton {
  id: notificationService

  property list<var> notifications: []
  property bool doNotDisturb: false
  readonly property int count: notifications.length
  property int _seqCounter: 0

  Component {
    id: notifDataComp
    NotificationData {}
  }

  NotificationServer {
    id: server
    actionsSupported:    true
    bodySupported:       true
    bodyMarkupSupported: true
    imageSupported:      true
    keepOnReload:        false

    onNotification: function(notification) {
      if (notificationService.doNotDisturb) return;

      if (!notification.appName && !notification.summary
        && !notification.body && !notification.image) return;

      notification.tracked = true;

      const idStr = String(notification.id || "");
      if (idStr !== "") {
        const existing = notificationService.notifications.find(function(n) {
          return n.notifId === idStr;
        });

        if (existing && !existing.closed) {
          existing.closed = true;
          notificationService.notifications = notificationService.notifications.filter(function(n) {
            return n !== existing;
          });

          existing.destroy();
        }
      }

      const data = notifDataComp.createObject(notificationService, {
        notification: notification,
        seqId: String(notificationService._seqCounter++)
      });

      notificationService.notifications = [data, ...notificationService.notifications];

      if (notificationService.notifications.length > 5)
        notificationService.notifications[notificationService.notifications.length - 1].dismiss();
    }
  }

  function _remove(notifData): void {
    notificationService.notifications = notificationService.notifications.filter(function(n) {
      return n !== notifData;
    });
  }

  function dismiss(notifData): void {
    if (notifData) notifData.dismiss();
  }

  function dismissAll(): void {
    const toRemove = [...notificationService.notifications];
    notificationService.notifications = [];
    for (const n of toRemove) {
      if (!n.closed) {
        n.closed = true;
        if (n.notification) try { n.notification.dismiss(); } catch(e) {}
        n.destroy();
      }
    }
  }
}
