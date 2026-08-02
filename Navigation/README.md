# Navigation

Moving between screens and passing data — push/pop, modal presentation, tab bars, and getting a result back.

## Files

- [`ProgrammaticNavigation.swift`](./ProgrammaticNavigation.swift) — push, pop, present, dismiss, and passing data both ways.
- [`TabBarSetup.swift`](./TabBarSetup.swift) — build a `UITabBarController` in code.

## Cheat sheet

| Goal | Code |
|---|---|
| Push a screen | `navigationController?.pushViewController(vc, animated: true)` |
| Go back | `navigationController?.popViewController(animated: true)` |
| Back to root | `navigationController?.popToRootViewController(animated: true)` |
| Present modally | `present(vc, animated: true)` |
| Dismiss modal | `dismiss(animated: true)` |
| Large titles | `navigationController?.navigationBar.prefersLargeTitles = true` |
| Right bar button | `navigationItem.rightBarButtonItem = UIBarButtonItem(...)` |

## Passing data

- **Forward** (to the next screen): inject via the destination's initializer. Prefer this over setting properties after `init`.
- **Backward** (returning a result): use a **closure callback** (simplest) or a delegate protocol.

```swift
// Forward
let detail = DetailViewController(item: selectedItem)

// Backward — closure
let picker = ColorPickerViewController()
picker.onPick = { [weak self] color in self?.apply(color) }
present(picker, animated: true)
```
