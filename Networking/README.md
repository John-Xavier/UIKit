# Networking

Talk to a REST API with `URLSession` + `Codable`, using modern async/await. No third-party dependency needed for the common cases.

## Files

- [`Models.swift`](./Models.swift) — example `Codable` models.
- [`APIService.swift`](./APIService.swift) — a reusable client: GET, POST, decoding, typed errors.

## Step by step (GET + decode)

1. Define a `Codable` struct that mirrors the JSON.
2. Build a `URLRequest` (URL, method, headers).
3. `let (data, response) = try await URLSession.shared.data(for: request)`.
4. Check the `HTTPURLResponse.statusCode` is in `200..<300`.
5. `try JSONDecoder().decode(Model.self, from: data)`.
6. Call it from a VC inside a `Task { }` and update UI on the main actor.

## Calling it from a view controller

```swift
Task {
    do {
        let users = try await APIService.shared.fetchUsers()
        self.users = users
        self.tableView.reloadData()          // already on main thread — see note
    } catch {
        self.showError(error)                // see ../Alerts
    }
}
```

> **Threading:** `await` resumes on the actor you started from. If you kick off the `Task` from a UI callback (which runs on the main actor), UI updates after `await` are already on the main thread. When in doubt, wrap UI in `await MainActor.run { ... }`.

## Common gotchas

- **Snake_case JSON?** Set `decoder.keyDecodingStrategy = .convertFromSnakeCase`.
- **Dates?** Set `decoder.dateDecodingStrategy = .iso8601` (or a custom formatter).
- **Optional fields:** make the Swift property optional (`String?`) — decoding throws otherwise.
- **App Transport Security:** plain `http://` is blocked by default; use `https` or configure ATS in Info.plist.
