# Guide 02 — Build a Screen: List → Detail

The single most common flow in any app: **fetch data → show it in a list → tap a row → see details.** This ties together several snippets in this repo.

Pieces used:
- [`../Networking/APIService.swift`](../Networking/APIService.swift) — fetch the data
- [`../TableView`](../TableView) — show the list
- [`../Navigation`](../Navigation) — push the detail
- [`../Alerts`](../Alerts) — surface errors

## The plan

```
UsersViewController (table)
      │  fetch users on viewDidLoad
      │  tap a row
      ▼
UserDetailViewController (fed the tapped User)
```

## Step 1 — Model & service

Already built: `User` in `Models.swift`, `APIService.shared.fetchUsers()`.

## Step 2 — The list view controller

```swift
final class UsersViewController: UITableViewController {

    private var users: [User] = []
    private static let cellID = "UserCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)
        loadUsers()
    }

    private func loadUsers() {
        Task {
            do {
                users = try await APIService.shared.fetchUsers()
                tableView.reloadData()
            } catch {
                showError(error)   // from ../Alerts
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection s: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: ip)
        var content = cell.defaultContentConfiguration()
        content.text = users[ip.row].name
        content.secondaryText = users[ip.row].email
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt ip: IndexPath) {
        tableView.deselectRow(at: ip, animated: true)
        let detail = UserDetailViewController(user: users[ip.row])   // forward data via init
        navigationController?.pushViewController(detail, animated: true)
    }
}
```

## Step 3 — The detail view controller

```swift
final class UserDetailViewController: UIViewController {
    private let user: User
    init(user: User) { self.user = user; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = user.name

        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\(user.name)\n@\(user.username)\n\(user.email)"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
```

## Why inject via `init`?

Passing `user` through the initializer makes it **impossible** to present the detail screen without its data — the compiler enforces it. That's safer than a `var user: User?` you might forget to set.

## Where to go next

- Add a loading spinner (`UIActivityIndicatorView`) while fetching.
- Add pull-to-refresh: `tableView.refreshControl = UIRefreshControl()`.
- Swap the manual `reloadData()` for a diffable data source (see `../TableView/DiffableTableViewController.swift`).
