# Guide 03 — Architecture: MVC vs MVVM

UIKit ships with MVC. Done naively it becomes **Massive View Controller** — a 1,000-line file doing networking, formatting, and layout. Here's how to keep it sane, and when MVVM helps.

## Apple MVC (the default)

```
Model  ──►  ViewController  ──►  View
 (data)      (glue + logic)      (UIKit)
```

The View Controller owns the views, responds to events, and talks to the model. Fine for small screens.

**It rots when** the VC also does: networking, JSON parsing, date formatting, validation, and business rules. Symptoms: giant files, no unit tests, copy-pasted logic.

### Keep MVC healthy

- Push networking into a **service** (`APIService`) — the VC just calls `await fetch()`.
- Push persistence into a **store** (`FileStorage`).
- Put reusable formatting in **model computed properties** or small helpers.
- Build cells as their **own classes** (`CustomCell`), not inline closures.

That alone fixes 80% of "Massive VC" pain without any new pattern.

## MVVM (when MVC isn't enough)

Add a **ViewModel** between the model and the VC. It holds presentation state and exposes ready-to-display values, so the VC only binds and renders.

```
Model ──► ViewModel ──► ViewController ──► View
          (state +      (binds + renders)
           formatting)
```

```swift
final class ProfileViewModel {
    private let user: User
    init(user: User) { self.user = user }

    var displayName: String { user.name.uppercased() }
    var handle: String { "@\(user.username)" }
    var onChange: (() -> Void)?   // simplest "binding": a callback
}

// In the VC:
let vm = ProfileViewModel(user: user)
nameLabel.text = vm.displayName
vm.onChange = { [weak self] in self?.render() }
```

### Benefits
- The ViewModel is a **plain object you can unit test** without a running UI.
- Formatting/state logic lives out of the VC.

### Costs
- More files and indirection. Overkill for a static screen.

## Binding options (from simplest)

1. **Closures / callbacks** — `var onChange: (() -> Void)?`. Zero dependencies.
2. **Combine** — `@Published` + `sink`. Great on iOS 13+, built in.
3. **Delegates** — classic, verbose, explicit.

## Rule of thumb

- Simple screen (static form, a list) → **MVC**, with services extracted.
- Screen with lots of derived/formatted state, or one you want to test → **MVVM**.
- Don't adopt a pattern because it's fashionable; adopt it when a file is getting hard to change.
