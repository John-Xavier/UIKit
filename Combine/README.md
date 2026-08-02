# Combine Binding

Combine (built into iOS 13+) is Apple's reactive framework. In UIKit it shines for **binding a ViewModel's state to your views** without manual `didSet`/reload plumbing — the MVVM "binding" layer from [Guide 03](../Guides/03-Architecture-MVC-vs-MVVM.md).

## Files

- [`FormViewModel.swift`](./FormViewModel.swift) — a `@Published`-driven view model with live validation.
- [`CombineBindingViewController.swift`](./CombineBindingViewController.swift) — binds text fields ⇄ view model and reacts to state.

## The three things you'll use 90% of the time

```swift
import Combine
private var cancellables = Set<AnyCancellable>()   // 1. hold subscriptions

// 2. React to a published value.
viewModel.$isValid
    .sink { [weak self] valid in self?.button.isEnabled = valid }
    .store(in: &cancellables)

// 3. Pipe a control's events INTO the view model.
NotificationCenter.default
    .publisher(for: UITextField.textDidChangeNotification, object: emailField)
    .compactMap { ($0.object as? UITextField)?.text }
    .assign(to: \.email, on: viewModel)
    .store(in: &cancellables)
```

## Key rules

- **Store every subscription** in a `Set<AnyCancellable>` on the object, or it's cancelled immediately.
- **`[weak self]`** in `sink`/`receive` closures to avoid retain cycles.
- Marshal to the UI thread with **`.receive(on: DispatchQueue.main)`** before `sink`ing if the publisher emits off-main (e.g. a network publisher).
- `@Published` lives on a class; access the publisher with the **`$`** prefix (`$email`).

## Operators worth knowing

| Operator | Use |
|---|---|
| `map` / `compactMap` | Transform values (and drop nils) |
| `combineLatest` | Merge two streams (e.g. email + password → isValid) |
| `debounce` | Wait for typing to pause (great for search) |
| `removeDuplicates` | Ignore repeated identical values |
| `filter` | Only pass values that match |
