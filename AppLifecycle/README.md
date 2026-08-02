# App Lifecycle — Running Code in Different Phases

Where to run code when the app **launches, goes to the background, comes back, or is about to be killed** — plus how to keep working briefly after the user leaves.

## Files

- [`SceneLifecycle.swift`](./SceneLifecycle.swift) — every `UIWindowSceneDelegate` phase callback with what belongs in each.
- [`BackgroundWork.swift`](./BackgroundWork.swift) — finish a task after backgrounding + schedule real background refresh with `BGTaskScheduler`.

## The states

```
Not running ──launch──► Inactive ──►  Active   (foreground, receiving events)
                           ▲   │
                           │   ▼
                        Foreground  ⇄  Background ──► Suspended ──► (terminated)
```

- **Active** — on screen, receiving events. Normal running.
- **Inactive** — foreground but *not* receiving events: during a phone call, in the app switcher, while a system prompt is up. Brief, transitional.
- **Background** — off screen but still running code, for a few seconds. Save state here.
- **Suspended** — frozen in memory, no code runs. The system may kill it anytime.

## Where things go (modern, scene-based — iOS 13+)

| Callback (`UIWindowSceneDelegate`) | Fires when | Put here |
|---|---|---|
| `scene(_:willConnectTo:options:)` | Scene is being created | Build the UI, set root VC |
| `sceneDidBecomeActive` | Became Active | Resume work, restart timers, refresh UI |
| `sceneWillResignActive` | About to go Inactive | Pause animations/timers, blur sensitive UI |
| `sceneDidEnterBackground` | Now in Background | **Save data**, release resources, schedule bg tasks |
| `sceneWillEnterForeground` | Coming back to foreground | Undo background prep, prefetch |
| `sceneDidDisconnect` | Scene released | Clean up scene-specific resources |

> **App-wide, scene-independent events** (first launch, push registration, `BGTaskScheduler` registration) still go in **`AppDelegate`** — `didFinishLaunchingWithOptions`. Scene delegates handle per-window UI state; the app delegate handles process-level concerns.

## Two rules that save you

1. **Save state in `sceneDidEnterBackground`, not later.** Once suspended, no code runs, and the app can be killed without another callback.
2. **Don't assume you get `willTerminate`.** For a suspended app it's usually never called — treat backgrounding as your last chance.

## Keep running briefly after backgrounding

The OS gives you ~30s. Wrap the work in a **background task** so you're not cut off mid-save (see `BackgroundWork.swift`). For real periodic work (fetching, cleanup) use **`BGTaskScheduler`** — the system runs it when convenient.
