# Animations

The everyday UIKit animation toolkit — no external libraries.

## Files

- [`AnimationExamples.swift`](./AnimationExamples.swift) — fade, move, scale, spring, shake, and view-property-animator control.

## The 3 APIs, ranked by when to use them

### 1. `UIView.animate` — 95% of cases
```swift
UIView.animate(withDuration: 0.3) {
    view.alpha = 0
    view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
}
```
Animatable properties: `frame`, `bounds`, `center`, `transform`, `alpha`, `backgroundColor`.

### 2. Spring animation — natural, bouncy motion
```swift
UIView.animate(withDuration: 0.5, delay: 0,
               usingSpringWithDamping: 0.6,      // 0 = very bouncy, 1 = no bounce
               initialSpringVelocity: 0.8,
               options: [.curveEaseOut]) {
    view.transform = .identity
}
```

### 3. `UIViewPropertyAnimator` — when you need to pause/scrub/reverse
```swift
let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
    view.alpha = 1
}
animator.startAnimation()
// later: animator.pauseAnimation(); animator.fractionComplete = 0.5
```

## Key rules

- **Animate the `transform`, not the frame,** when you can — it's GPU-accelerated and composes cleanly.
- To animate an Auto Layout change: set the constraint constants, then call `self.view.layoutIfNeeded()` **inside** the animation block.
- `.transform = .identity` resets any scale/rotate/translate back to normal.
- Run repeating animations with options `[.repeat, .autoreverse]`.

## Auto Layout animation pattern

```swift
heightConstraint.constant = 200
UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
```
