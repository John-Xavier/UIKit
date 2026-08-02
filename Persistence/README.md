# Persistence

Save data between launches. Two of the most common lightweight options:

## Files

- [`UserDefaultsStore.swift`](./UserDefaultsStore.swift) — type-safe UserDefaults via `@propertyWrapper` (good for small settings/flags).
- [`CodableFileStorage.swift`](./CodableFileStorage.swift) — save/load any `Codable` model as JSON in the Documents directory (good for arrays of models).

## Which one?

| Need | Use |
|---|---|
| A bool flag, a string, a small setting | UserDefaults |
| A cached list of models, offline data | Codable → JSON file |
| Large/relational data, queries | Core Data or SQLite (not covered here) |
| Secrets, tokens, passwords | **Keychain** — never UserDefaults |

## Step by step (Codable to disk)

1. Make your model `Codable`.
2. Encode with `JSONEncoder` → `Data`.
3. Write to a URL in `FileManager.default.urls(for: .documentDirectory, ...)`.
4. To load: read the `Data` back and `JSONDecoder().decode`.
5. Handle the "file doesn't exist yet" case by returning a default.

> ⚠️ Never store passwords or auth tokens in UserDefaults or a plist — they're plain text. Use the Keychain.
