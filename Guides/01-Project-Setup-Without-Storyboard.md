# Guide 01 — Project Setup Without Storyboard

Most of the snippets in this repo assume a programmatic, storyboard-free project. Here's the full setup, top to bottom.

## Why go storyboard-free?

- **Merge-friendly:** storyboard XML produces awful git conflicts on a team.
- **Explicit:** everything the screen does is visible in code — no hidden IB connections.
- **Reusable:** views built in code are trivial to reuse and unit-friendly.

Trade-off: you write more layout code. Stack views (see `../AutoLayout`) keep it manageable.

## Steps

### 1. Create the project
Xcode → New Project → **App**. Language: Swift. Interface: **Storyboard** (we'll remove it — the "SwiftUI" option scaffolds a different lifecycle).

### 2. Delete `Main.storyboard`
Select it in the navigator → Delete → **Move to Trash**.

### 3. Remove the storyboard references (two places)
1. **Target → General → Deployment Info → Main Interface:** clear the field (it says `Main`).
2. **Info.plist → Application Scene Manifest → Scene Configuration → Application Session Role → Item 0:** delete the **`Storyboard Name`** row (`UISceneStoryboardFile`).

If you skip either, you'll get a black screen on launch.

### 4. Set the root controller in `SceneDelegate`
See [`../AppSetup/SceneDelegate.swift`](../AppSetup/SceneDelegate.swift). The key lines:

```swift
let window = UIWindow(windowScene: windowScene)
window.rootViewController = UINavigationController(rootViewController: ViewController())
window.makeKeyAndVisible()
self.window = window
```

### 5. Build & run
You should see your view controller full screen. If you see black, revisit step 3.

## Checklist

- [ ] `Main.storyboard` deleted
- [ ] "Main Interface" field empty
- [ ] `UISceneStoryboardFile` removed from Info.plist
- [ ] `window.makeKeyAndVisible()` called in `SceneDelegate`
- [ ] `self.window = window` assigned (forgetting this = blank screen)
