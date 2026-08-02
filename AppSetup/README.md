# App Setup — No Storyboard

Get an app running with **zero storyboards**, setting the root view controller in code. This is the foundation every other snippet assumes.

## Step by step

1. **Create a new iOS App project** in Xcode (Interface: Storyboard is fine — we'll remove it).
2. **Delete `Main.storyboard`** from the project navigator (move to trash).
3. **Remove the storyboard reference** in two places:
   - `Info.plist` → delete the key **`UIApplication Scene Manifest → Scene Configuration → ... → Storyboard Name`** (the `UISceneStoryboardFile` entry).
   - Target → **General → Deployment Info → Main Interface**: clear the text field.
4. **Replace `SceneDelegate.swift`** with the code below.
5. Build & run — you should see your `ViewController` full screen.

## Files

- [`SceneDelegate.swift`](./SceneDelegate.swift) — sets up the window and root controller.

## Wrapping the root controller

Most apps want a navigation bar or tab bar at the root:

```swift
// Navigation stack
window.rootViewController = UINavigationController(rootViewController: HomeViewController())

// Tab bar (see ../Navigation for a full example)
window.rootViewController = makeTabBarController()
```
