# Popular Libraries Used with UIKit

A curated reference of the third-party libraries you'll see most often in real UIKit projects — what each does, when it's worth adding, and the first-party alternative if there is one. **Docs-only.**

> **Add most of these via Swift Package Manager:** Xcode → *File → Add Packages…* → paste the repo URL → pick the product. CocoaPods/Carthage still work but SPM is the default today.

> **Rule of thumb:** every dependency is code you don't control and must keep updated. Prefer the first-party option when it's good enough (columns below), and add a library when it clearly saves real work.

---

## Networking

| Library | What it does | Add it when… | First-party alternative |
|---|---|---|---|
| **Alamofire** | Elegant HTTP networking: requests, multipart upload, retry, interceptors, reachability | You need interceptors/retry/multipart and lots of endpoints | `URLSession` + async/await (see [`../Networking`](../Networking)) |
| **Moya** | Type-safe network layer built on Alamofire (enum-driven API targets) | You want a strongly-typed abstraction over your API | Hand-rolled `APIService` |

## Images

| Library | What it does | Add it when… | First-party alternative |
|---|---|---|---|
| **Kingfisher** | Async image download + memory/disk cache, `imageView.kf.setImage(with:)`, processors, placeholders | You need disk caching, downsampling, transitions | The small loader in [`../ImageLoading`](../ImageLoading) |
| **SDWebImage** | The long-standing image cache library (Obj-C origins, huge adoption) | You're maintaining an older codebase or need its format support | Same as above |
| **Nuke** | Modern, fast, Swift-first image loading & caching | You want a lean Swift-native alternative to Kingfisher | Same as above |

## Layout

| Library | What it does | Add it when… | First-party alternative |
|---|---|---|---|
| **SnapKit** | Concise Auto Layout DSL: `view.snp.makeConstraints { $0.edges.equalToSuperview() }` | Your team prefers a terse constraint syntax | Anchors / stack views (see [`../AutoLayout`](../AutoLayout)) |
| **TinyConstraints** | Even shorter anchor helpers (`view.edgesToSuperview()`) | You want minimal constraint boilerplate | Same |

## Reactive / architecture

| Library | What it does | Add it when… | First-party alternative |
|---|---|---|---|
| **RxSwift / RxCocoa** | Full reactive programming; UIKit bindings | A large app already standardized on Rx | **Combine** (see [`../Combine`](../Combine)) |
| **Combine** *(Apple)* | First-party reactive framework, iOS 13+ | New projects wanting reactive bindings | — (this *is* the native option) |

## Persistence & database

| Library | What it does | Add it when… | First-party alternative |
|---|---|---|---|
| **Realm** | Fast object database, live/observable objects, simple API | You want less ceremony than Core Data + live queries | Core Data (see [`../CoreData`](../CoreData)) |
| **GRDB** | SQLite toolkit with a great Swift API, migrations, observation | You think in SQL and want control | Core Data / SwiftData (iOS 17+) |
| **KeychainAccess** | Ergonomic wrapper over the Keychain for secrets/tokens | You store credentials (never use UserDefaults for these) | Raw Keychain Services API |

## UI, UX & animation

| Library | What it does | Add it when… | First-party alternative |
|---|---|---|---|
| **Lottie** | Renders After Effects animations from JSON | Designers hand you rich vector animations | `UIView.animate` / `CAAnimation` (see [`../Animations`](../Animations)) |
| **SkeletonView** | Shimmering skeleton loading placeholders | You want polished loading states | Hand-built placeholder views |
| **IQKeyboardManager** | Drop-in automatic keyboard avoidance for every text field | You want keyboard handling without per-screen code | Manual handling (see [`../Forms`](../Forms)) |
| **Hero** | Declarative view-controller transition animations | You want shared-element / custom transitions cheaply | `UIViewControllerTransitioningDelegate` |
| **SVProgressHUD / MBProgressHUD** | Ready-made loading / progress HUDs | You want a quick spinner overlay | `UIActivityIndicatorView` |

## Charts

| Library | What it does | Add it when… | First-party alternative |
|---|---|---|---|
| **DGCharts** | Rich interactive charts (bar/line/pie/…), gestures, animations | Pre-iOS-16 support or you need many chart types | **Swift Charts** iOS 16+ (see [`../Charts`](../Charts)) |

## Backend, analytics & crash reporting

| Library | What it does | Add it when… |
|---|---|---|
| **Firebase** | Push (FCM), analytics, Crashlytics, Remote Config, Auth, Firestore | You want a batteries-included backend (see [`../FirebaseNotifications`](../FirebaseNotifications)) |
| **Sentry** | Crash & error reporting with stack traces and breadcrumbs | You need production error visibility |

## Developer tooling (not shipped in the app)

| Tool | What it does | Notes |
|---|---|---|
| **SwiftLint** | Enforces style & catches issues at build time | Add a build phase; configure with `.swiftlint.yml` |
| **SwiftFormat** | Auto-formats Swift on save / in CI | Pairs well with SwiftLint |
| **Fastlane** | Automates building, signing, screenshots, TestFlight/App Store uploads | Ruby-based; run in CI |
| **R.swift / SwiftGen** | Generate type-safe accessors for assets, colors, strings, storyboards | Kills stringly-typed `UIImage(named:)` bugs |

---

## How to choose (quick heuristics)

1. **Is there a good first-party option?** (Combine, Swift Charts, URLSession, Core Data.) Start there.
2. **Does the library save days, not minutes?** Alamofire, Kingfisher, Lottie, Firebase usually do.
3. **Check health before adding:** recent commits, open-issue ratio, stars, SPM support, and whether it still works on the latest iOS/Xcode.
4. **Isolate it.** Wrap third-party APIs behind your own protocol/service so swapping later touches one file, not fifty.
5. **Fewer is better.** Each dependency is build time, binary size, and a future migration you'll own.
