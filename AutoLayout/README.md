# Auto Layout (Programmatic)

Lay out views in code with anchors and stack views. Two rules cover 90% of cases:

1. Set **`translatesAutoresizingMaskIntoConstraints = false`** on every view you constrain.
2. **`NSLayoutConstraint.activate([...])`** your constraints in one batch.

## Files

- [`AutoLayoutExamples.swift`](./AutoLayoutExamples.swift) — pin-to-edges, center, safe area, stack views, and priorities.

## Anchor cheat sheet

```swift
// Pin all four edges to a parent
NSLayoutConstraint.activate([
    child.topAnchor.constraint(equalTo: parent.topAnchor),
    child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
    child.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
    child.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
])

// Center + fixed size
child.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
child.widthAnchor.constraint(equalToConstant: 200)

// Respect the notch / home indicator
child.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)

// Respect readable margins
child.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
```

## When to use `UIStackView`

Reach for a stack view before writing constraints by hand. It handles spacing, distribution, and alignment for rows/columns of views and dramatically cuts constraint count. Only drop to raw anchors when you need overlap or precise positioning a stack can't express.

## Priorities & hugging/compression

- **Content hugging** (default 250): how hard a view resists *growing*. Raise it so a label doesn't stretch.
- **Compression resistance** (default 750): how hard a view resists *shrinking*. Raise it so a label isn't clipped.
- Give a "should break first" constraint a priority like `.defaultHigh` (750) so Auto Layout knows what to sacrifice.
