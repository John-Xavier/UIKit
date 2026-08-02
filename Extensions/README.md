# Handy UIKit Extensions

Small, reusable extensions that remove boilerplate you'd otherwise rewrite in every project. **Code-only** — drop the files in and use.

## Files

- [`UIView+Extensions.swift`](./UIView+Extensions.swift) — add multiple subviews, pin-to-edges, corner radius, shadow, "find my view controller".
- [`UIColor+Hex.swift`](./UIColor+Hex.swift) — create colors from hex strings/ints.
- [`UIImageView+Loading.swift`](./UIImageView+Loading.swift) — one-liner async image loading with a placeholder.

## Highlights

```swift
view.addSubviews(label, button, imageView)     // variadic
child.pinToEdges(of: parent)                    // one call, four constraints
card.roundCorners(12)
card.addShadow()

label.textColor = UIColor(hex: "#FF6B35")

avatarView.setImage(from: url, placeholder: UIImage(systemName: "person"))
```

> These are deliberately dependency-free. `setImage(from:)` reuses [`../ImageLoading/ImageLoader.swift`](../ImageLoading/ImageLoader.swift).
