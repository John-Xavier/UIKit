# UIStackView Form + Keyboard Avoidance

A scrollable form built with a stack view that **moves out of the way of the keyboard** so the active text field is never hidden. This is the pattern for login/signup/settings screens.

## Files

- [`KeyboardAvoidingFormViewController.swift`](./KeyboardAvoidingFormViewController.swift) — full form: scroll view + stack view + keyboard handling + "next field" chaining.

## The recipe

1. Put a **`UIScrollView`** filling the screen.
2. Put a vertical **`UIStackView`** inside it holding the fields.
3. Pin the stack to the scroll view's **`contentLayoutGuide`** (defines scrollable size) and match width to the **`frameLayoutGuide`** (so it doesn't scroll sideways).
4. Observe **keyboard notifications** and adjust the scroll view's `contentInset.bottom` by the keyboard height.
5. Scroll the active field into view.

## Keyboard avoidance — the core

```swift
NotificationCenter.default.addObserver(
    self, selector: #selector(keyboardWillChange),
    name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

@objc func keyboardWillChange(_ note: Notification) {
    guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        as? NSValue else { return }
    let keyboardHeight = view.bounds.height - frame.cgRectValue.minY
    scrollView.contentInset.bottom = max(0, keyboardHeight)
    scrollView.verticalScrollIndicatorInsets.bottom = max(0, keyboardHeight)
}
```

Using `keyboardWillChangeFrame` (not just `willShow`/`willHide`) handles the keyboard resizing, autocomplete bar, and hardware-keyboard cases in one handler.

## Nice-to-haves included

- **Tap-to-dismiss:** tap anywhere outside a field to resign.
- **Return key chaining:** pressing "Next" jumps to the following field; "Done" submits.
- **`textContentType`** hints so iOS offers autofill (email, password, one-time-code).
