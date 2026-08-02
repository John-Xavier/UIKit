# Profile Page

A classic profile screen: a **header** with avatar + name + stats, sitting above a **settings-style table view**. This is the pattern behind most "Account" / "Me" tabs.

## Files

- [`ProfileHeaderView.swift`](./ProfileHeaderView.swift) — the reusable header (avatar, name, follower/following stats).
- [`ProfileViewController.swift`](./ProfileViewController.swift) — hosts the header as `tableHeaderView` and drives grouped settings rows.

## Step by step

1. Build the header as a plain `UIView` subclass with its own Auto Layout.
2. Create a grouped table (`style: .insetGrouped`).
3. Assign the header to `tableView.tableHeaderView` and **give it an explicit width + a computed height** (table headers don't auto-size).
4. Populate grouped rows (Edit Profile, Notifications, Privacy, Log Out…).

## The one tricky bit: sizing `tableHeaderView`

A `tableHeaderView` won't respect Auto Layout by itself. Size it manually after layout:

```swift
if let header = tableView.tableHeaderView {
    let targetSize = CGSize(width: tableView.bounds.width,
                            height: UIView.layoutFittingCompressedSize.height)
    let height = header.systemLayoutSizeFitting(
        targetSize,
        withHorizontalFittingPriority: .required,
        verticalFittingPriority: .fittingSizeLevel).height
    if header.frame.height != height {
        header.frame.size.height = height
        tableView.tableHeaderView = header // re-assign to apply
    }
}
```

Call this from `viewDidLayoutSubviews()`.
