import UIKit
import UserNotifications

// APNs registration + handling. Put this logic in your AppDelegate.
// Enable "Push Notifications" capability first (see README).
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        return true
    }

    private func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                guard granted else { return }
                // Registering must happen on the main thread.
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
    }

    // MARK: - APNs token callbacks

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert the raw token to the hex string your server needs.
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNs device token: \(token)")
        // TODO: send `token` to your backend so it can push to this device.
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }

    // MARK: - Silent / background push (requires Background Modes → Remote notifications)

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler:
                     @escaping (UIBackgroundFetchResult) -> Void) {
        // Do a quick background refresh, then report the result.
        print("Silent push payload: \(userInfo)")
        completionHandler(.newData)
    }
}

// MARK: - Presenting & responding to notifications

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Show notifications even while the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    // Handle the user tapping a notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Tapped notification: \(userInfo)")
        // TODO: route the user to the relevant screen (deep link).
        completionHandler()
    }
}
