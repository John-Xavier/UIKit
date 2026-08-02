import Foundation

// A type-safe property wrapper over UserDefaults.
@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get { container.object(forKey: key) as? Value ?? defaultValue }
        set { container.set(newValue, forKey: key) }
    }
}

// Central place for all your app's simple settings.
enum Settings {
    @UserDefault(key: "hasSeenOnboarding", defaultValue: false)
    static var hasSeenOnboarding: Bool

    @UserDefault(key: "username", defaultValue: "")
    static var username: String

    @UserDefault(key: "launchCount", defaultValue: 0)
    static var launchCount: Int
}

// Usage:
//   Settings.hasSeenOnboarding = true
//   if !Settings.hasSeenOnboarding { showOnboarding() }
//   Settings.launchCount += 1
