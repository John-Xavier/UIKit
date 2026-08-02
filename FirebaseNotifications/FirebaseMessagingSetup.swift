import UIKit
import UserNotifications

// NOTE: These imports require the Firebase SDK (SPM) — see README.
// Uncomment once FirebaseCore and FirebaseMessaging are added to the target.
//
// import FirebaseCore
// import FirebaseMessaging

// Firebase Cloud Messaging wiring. Replace the pseudo-calls below once the SDK
// is added; the structure is exactly what you need.
final class FirebaseAppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // 1. Initialise Firebase (reads GoogleService-Info.plist).
        // FirebaseApp.configure()

        // 2. Become the FCM + notification delegate.
        // Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        // 3. Ask permission and register with APNs.
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                guard granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        return true
    }

    // Hand the raw APNs token to Firebase so it can mint an FCM token.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - FCM token delegate
// extension FirebaseAppDelegate: MessagingDelegate {
//     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//         guard let fcmToken else { return }
//         print("FCM token: \(fcmToken)")
//         // TODO: send this token to your backend — you push to THIS, not the APNs token.
//     }
// }

// MARK: - Foreground presentation + taps (same as raw APNs)
extension FirebaseAppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Tapped FCM notification: \(userInfo)")
        completionHandler()
    }
}
