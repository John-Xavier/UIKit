# Firebase Cloud Messaging (FCM)

Firebase Messaging sits **on top of APNs** and gives you a simpler token, a web console to send test pushes, topic subscriptions, and cross-platform delivery. Under the hood it still uses APNs on iOS — so the APNs capability setup from [`../PushNotifications`](../PushNotifications) is still required.

## Files

- [`FirebaseMessagingSetup.swift`](./FirebaseMessagingSetup.swift) — AppDelegate wiring for Firebase + FCM tokens.

## One-time setup

1. **Create a Firebase project** at console.firebase.google.com and add an iOS app (use your bundle ID).
2. Download **`GoogleService-Info.plist`** and drag it into the Xcode project (check "Copy if needed", add to target).
3. **Add the SDK** via Swift Package Manager:
   - File → Add Packages → `https://github.com/firebase/firebase-ios-sdk`
   - Add the products **`FirebaseCore`** and **`FirebaseMessaging`**.
4. **Enable Push Notifications + Background Modes → Remote notifications** capabilities (same as raw APNs).
5. **Upload your APNs auth key** (`.p8`) to Firebase Console → Project Settings → Cloud Messaging. Without this, Firebase can't reach APNs and no pushes arrive.
6. Wire up the AppDelegate (see the code file).

## The token you actually use

With FCM you send to the **FCM registration token**, not the raw APNs token. Get it from `messaging.token` and in `messaging(_:didReceiveRegistrationToken:)`. Send *that* to your backend.

## Sending a test

Firebase Console → **Messaging → New campaign / Send test message** → paste an FCM token. Or from your server, POST to the FCM HTTP v1 API with the token.

## FCM vs raw APNs — which?

| Prefer FCM when… | Prefer raw APNs when… |
|---|---|
| You want a console to send test pushes | You want zero third-party SDKs |
| You need topic/segment sends | You already have an APNs-capable backend |
| You're cross-platform (also Android/web) | You want the smallest binary / no analytics |

> Note: this folder's code **won't compile until the Firebase SDK is added** — the `import FirebaseCore` / `import FirebaseMessaging` lines depend on the package from step 3.
