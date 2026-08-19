import Quickshell.Services.Notifications
import QtQuick

QtObject {
  id: root

  property Notification notification: null
  property bool closed: false

  property string seqId: ""
  property string notificationId: ""

  property string summary: ""
  property string body: ""
  property string appIcon: ""
  property string appName: ""
  property string image: ""
  property var    actions: []
  property int    urgency: NotificationUrgency.Normal
  property real   expireTimeout: 5

  property bool hovered: false

  readonly property Connections _conn: Connections {
    target: root.notification

    function onClosed(): void {
      if (root.closed) return

      root.closed = true
      NotificationService._remove(root)
      root.destroy()
    }

    function onSummaryChanged(): void {
      if (root.notification) root.summary = root.notification.summary || ""
    }

    function onBodyChanged(): void {
      if (root.notification) root.body = root.notification.body || ""
    }

    function onAppIconChanged(): void {
      if (root.notification) root.appIcon = root.notification.appIcon || ""
    }

    function onAppNameChanged(): void {
      if (root.notification) root.appName = root.notification.appName || ""
    }

    function onImageChanged(): void {
      if (root.notification) root.image = root.notification.image || ""
    }

    function onUrgencyChanged(): void {
      if (root.notification) root.urgency = root.notification.urgency
    }

    function onExpireTimeoutChanged(): void {
      if (root.notification) root.expireTimeout = root.notification.expireTimeout
    }

    function onActionsChanged(): void {
      if (!root.notification) return
      root.actions = root.notification.actions.map(function(a) {
          return { identifier: a.identifier, text: a.text }
      })
    }
  }

  readonly property Timer _timer: Timer {
    running: !root.closed
      && !root.hovered
      && root.urgency !== NotificationUrgency.Critical
    interval: root.expireTimeout ? root.expireTimeout * 1000 : 5000
    onTriggered: root.dismiss()
  }

  Component.onCompleted: {
    if (!root.notification) return

    root.notificationId = String(root.notification.id || "")
    root.summary = root.notification.summary || ""
    root.body = root.notification.body || ""
    root.appIcon = root.notification.appIcon || ""
    root.appName = root.notification.appName || ""
    root.image = root.notification.image || ""
    root.urgency = root.notification.urgency
    root.expireTimeout = root.notification.expireTimeout > 0 ? root.notification.expireTimeout : 5
    actions = root.notification.actions.map(function(a) {
      return { identifier: a.identifier, text: a.text }
    })
  }

  function dismiss(): void {
    if (root.closed) return

    root.closed = true
    NotificationService._remove(root)

    if (root.notification) try { root.notification.dismiss() } catch(e) {}
  }

  function invokeAction(identifier): void {
    if (!root.notification || !identifier || root.closed) return

    root.closed = true
    NotificationService._remove(root)

    const action = root.notification.actions.find(function(a) {
      return a.identifier === identifier
    })

    if (action) try { action.invoke() } catch(e) {}
  }

  function getIcon(): string {
    if (root.appIcon) return root.appIcon
    if (root.urgency === NotificationUrgency.Critical) return ""
    if (root.urgency === NotificationUrgency.Low) return ""
    return ""
  }
}
