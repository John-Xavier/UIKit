# Guide 04 — Debugging & Common Crashes

The errors every UIKit developer hits, what they mean, and the fix.

## "Unable to simultaneously satisfy constraints" (purple/console spew)

Auto Layout has **conflicting constraints** and broke one to recover. The app still runs but the layout may be wrong.

- Read the console dump — it lists the conflicting constraints and which one it broke.
- Usual cause: a fixed height/width fighting a pin, or a missing constraint so a view has ambiguous position.
- Add the missing constraint, or lower the priority of the one that should yield (`.defaultHigh`).
- In LLDB: `po view.hasAmbiguousLayout` and `po view.constraintsAffectingLayout(for: .horizontal)`.

## `Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional`

A force-unwrap (`!`) or IBOutlet was nil.

- Common with IBOutlets not connected, or accessing views **before `viewDidLoad`**.
- Fix: use optional binding (`if let` / `guard let`) instead of `!`; make sure setup runs in `viewDidLoad`.

## `NSInternalInconsistencyException` — "invalid number of rows"

Your data source and your `insert/delete` calls disagree after a table update.

> "attempt to delete row 5 … but there are only 5 rows" — you must update the **model first**, then tell the table.

- Fix: mutate your array, *then* call `deleteRows`. Or switch to a **diffable data source** (`../TableView/DiffableTableViewController.swift`), which eliminates this entire class of bug.

## `unrecognized selector sent to instance`

A target/action points at a method that doesn't exist (typo, wrong signature).

- `#selector(buttonTapped)` must match a method like `@objc func buttonTapped()`. Add `@objc` and match the argument shape (`_ sender: UIButton`).

## UI updates that don't appear / freeze

You touched UIKit off the main thread.

- **All UIKit calls must be on the main thread.** After a background task:
  ```swift
  await MainActor.run { self.label.text = "Done" }   // async/await
  DispatchQueue.main.async { self.label.text = "Done" } // GCD
  ```
- Xcode's **Main Thread Checker** (on by default) will flag these with a purple runtime warning.

## Black screen on launch (programmatic setup)

- Forgot `window.makeKeyAndVisible()`, or didn't assign `self.window = window`.
- Left a storyboard reference in Info.plist. See [Guide 01](./01-Project-Setup-Without-Storyboard.md).

## Retain cycles (memory leaks)

A closure captures `self` strongly and never releases.

- Use `[weak self]` in escaping closures (network callbacks, `onChange`, `Task`):
  ```swift
  loader.onDone = { [weak self] in self?.reload() }
  ```
- Find them with **Instruments → Leaks** or the Memory Graph Debugger (the debug bar's cube icon).

## Handy LLDB commands

| Command | Does |
|---|---|
| `po someVariable` | Print an object's description |
| `p 2 + 2` | Evaluate an expression |
| `e someView.backgroundColor = .red` | Mutate live, then `continue` to see it |
| `bt` | Backtrace of the current thread |
| `image lookup -a <address>` | Symbolicate a raw crash address |
