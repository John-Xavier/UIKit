# Gestures

Recognize taps, swipes, pans, pinches, rotations, and long-presses with `UIGestureRecognizer`.

## Files

- [`GestureExamples.swift`](./GestureExamples.swift) — a view controller wiring up every common recognizer.

## The pattern (always the same 3 lines)

```swift
let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
view.addGestureRecognizer(tap)
view.isUserInteractionEnabled = true   // UIImageView/UILabel need this ON
```

## The recognizers

| Recognizer | Use | Configure |
|---|---|---|
| `UITapGestureRecognizer` | Taps | `numberOfTapsRequired` (double-tap = 2) |
| `UILongPressGestureRecognizer` | Press & hold | `minimumPressDuration` |
| `UISwipeGestureRecognizer` | Directional swipe | `direction = .left` (one per direction) |
| `UIPanGestureRecognizer` | Drag | read `translation(in:)` / `velocity(in:)` |
| `UIPinchGestureRecognizer` | Zoom | read `scale` |
| `UIRotationGestureRecognizer` | Rotate | read `rotation` |

## Gotchas

- **Enable interaction:** `UIImageView` and `UILabel` have `isUserInteractionEnabled = false` by default — turn it on.
- **Continuous gestures** (pan/pinch/rotation) fire repeatedly; check `gesture.state` (`.began`, `.changed`, `.ended`) and **reset the translation** after applying it:
  ```swift
  let t = pan.translation(in: view)
  view.center = CGPoint(x: view.center.x + t.x, y: view.center.y + t.y)
  pan.setTranslation(.zero, in: view)  // so the next delta is relative
  ```
- **Multiple at once:** implement `UIGestureRecognizerDelegate.gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)` returning `true` to pinch + rotate together.
- **Swipe needs a direction each:** add separate recognizers for left/right/up/down.
