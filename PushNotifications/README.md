# Push Notifications

Two kinds, both via `UserNotifications`:

- **Local notifications** — scheduled by your app, no server (reminders, alarms). Works offline.
- **Remote (push) notifications** — sent from a server through **APNs** to a device token.

## Files

- [`LocalNotifications.swift`](./LocalNotifications.swift) — request permission, schedule, cancel local notifications.
- [`RemoteNotifications.swift`](./RemoteNotifications.swift) — register for APNs, receive the device token, handle taps.

## Local notifications — step by step

1. Ask permission once: `requestAuthorization(options: [.alert, .sound, .badge])`.
2. Build a `UNMutableNotificationContent` (title, body, sound, badge).
3. Pick a **trigger** (time interval, calendar date, or location).
4. Add a `UNNotificationRequest` with a unique identifier.
5. Cancel by identifier when needed.

## Remote (APNs) — step by step

1. **Enable the capability:** target → Signing & Capabilities → **+ Push Notifications**. Add **Background Modes → Remote notifications** if you send silent pushes.
2. Request permission (same as local).
3. Call `UIApplication.shared.registerForRemoteNotifications()`.
4. Implement `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` — convert the token to hex and **send it to your server**.
5. Your server signs a request to APNs (`api.push.apple.com`) with that token + an auth key (`.p8`).
6. Handle taps in `UNUserNotificationCenterDelegate`.

> **You cannot test real push in the Simulator via APNs**, but you can drag a `.apns` JSON payload file onto the Simulator, or use `xcrun simctl push <device> <bundleID> payload.apns`.

## Foreground presentation

By default a push is **not shown** while your app is in the foreground. Opt in via the delegate:

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound, .badge])
}
```

## Payload shape (what your server sends)

```json
{
  "aps": {
    "alert": { "title": "New message", "body": "You have 1 unread" },
    "sound": "default",
    "badge": 1
  },
  "customKey": "customValue"
}
```
