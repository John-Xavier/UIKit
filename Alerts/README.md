# Alerts & Action Sheets

`UIAlertController` handles both alerts (centered) and action sheets (bottom). This section is **code-only** — grab the helper you need.

## Files

- [`Alerts.swift`](./Alerts.swift) — reusable `UIViewController` helpers for alerts, confirmations, destructive prompts, text input, and action sheets.

## Quick reference

```swift
showAlert(title: "Saved", message: "Your changes were saved.")

confirm(title: "Delete?", message: "This can't be undone.", confirmTitle: "Delete", destructive: true) {
    // user confirmed
}

promptForText(title: "New folder", placeholder: "Name") { name in
    // user typed `name`
}
```

## Gotcha: action sheets on iPad

On iPad, an action sheet is shown as a popover and **must** have a source view/bar button, or it crashes:

```swift
sheet.popoverPresentationController?.sourceView = someView
sheet.popoverPresentationController?.sourceRect = someView.bounds
```

The helper in `Alerts.swift` sets this for you when you pass a `sourceView`.
