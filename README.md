# UIKit Snippets & Recipes

A personal, copy-ready library of the code and functionality you reach for again and again in a **UIKit (iOS / Swift)** project. Everything here is **programmatic UIKit** (no storyboards) so snippets drop straight into any file — but the patterns apply equally if you use Interface Builder.

> **How to use this repo:** browse to a folder, read its `README.md` for the step-by-step, then copy the `.swift` file(s). Each snippet is self-contained and commented.

---

## 📑 Index

**Foundations**

| Section | What's inside | Type |
|---|---|---|
| [AppSetup](./AppSetup) | Launch the app with no storyboard, set the root view controller | Code + Docs |
| [AppLifecycle](./AppLifecycle) | Run code per phase (active/inactive/background), background tasks | Code + Docs |
| [AutoLayout](./AutoLayout) | Anchors, stack views, safe area, common layouts | Code + Docs |
| [Navigation](./Navigation) | Push/pop, passing data, tab bar, completion handlers | Code + Docs |

**Lists & content**

| Section | What's inside | Type |
|---|---|---|
| [TableView](./TableView) | Basic list, custom cells, sections, swipe actions, diffable data source | Code + Docs |
| [CollectionView](./CollectionView) | Image grid, async cells, compositional layout | Code + Docs |
| [RefreshPagination](./RefreshPagination) | Pull-to-refresh + infinite-scroll pagination | Code + Docs |
| [Search](./Search) | `UISearchController` filtering a list, scope buttons | Code + Docs |
| [Profile](./Profile) | Profile screen: image header + settings-style table | Code + Docs |

**Input, data & reactivity**

| Section | What's inside | Type |
|---|---|---|
| [Forms](./Forms) | Stack-view form with keyboard avoidance + field chaining | Code + Docs |
| [Combine](./Combine) | Bind a ViewModel's state to views reactively | Code + Docs |
| [Networking](./Networking) | `URLSession`, `Codable`, async/await, error handling | Code + Docs |
| [ImageLoading](./ImageLoading) | Async image download with an in-memory cache | Code + Docs |
| [Persistence](./Persistence) | UserDefaults wrapper, Codable to disk | Code + Docs |
| [CoreData](./CoreData) | Local database: stack + CRUD + fetched results controller | Code + Docs |

**Polish & platform**

| Section | What's inside | Type |
|---|---|---|
| [Animations](./Animations) | Fade, spring, shake, spin, property animator | Code + Docs |
| [Gestures](./Gestures) | Tap, long-press, pan, pinch, rotate, swipe | Code + Docs |
| [Alerts](./Alerts) | Alerts, action sheets, text-field prompts | Code |
| [Extensions](./Extensions) | Handy `UIView` / `UIColor` / `UIImageView` extensions | Code |
| [PushNotifications](./PushNotifications) | Local + remote (APNs): permission, token, handling | Code + Docs |
| [FirebaseNotifications](./FirebaseNotifications) | Firebase Cloud Messaging (FCM) setup on top of APNs | Code + Docs |
| [Guides](./Guides) | Longer step-by-step tutorials (setup, architecture, debugging) | Docs |

---

## 🧭 Conventions used everywhere

- **Programmatic Auto Layout** with `translatesAutoresizingMaskIntoConstraints = false` and anchor-based constraints.
- **Reuse identifiers** are `static let reuseID = "ClassName"` on the cell type.
- **`private lazy var`** for subviews so setup lives next to the declaration.
- **MARK: comments** to keep view controllers scannable.
- Minimum target assumed: **iOS 15+** (async/await, `UIListContentConfiguration`). Notes are added where an API needs a newer OS.

## ⚡ The 30-second mental model

```
SceneDelegate ──► sets rootViewController (usually a UINavigationController or UITabBarController)
      │
      └─► ViewController ──► adds subviews in loadView/viewDidLoad
                 │              activates Auto Layout constraints
                 └─► data source / delegate feed the UI
```

Start with [AppSetup](./AppSetup) if you're building from an empty project.
