# UITableView

The workhorse list view. This section goes from the simplest possible list to modern diffable data sources.

## Files

| File | Use it when… |
|---|---|
| [`BasicTableViewController.swift`](./BasicTableViewController.swift) | You need a plain list of strings, fast. |
| [`CustomCell.swift`](./CustomCell.swift) + [`CustomCellTableViewController.swift`](./CustomCellTableViewController.swift) | Each row needs its own layout (title, subtitle, image, badge). |
| [`SectionedTableViewController.swift`](./SectionedTableViewController.swift) | You need grouped rows with section headers. |
| [`SwipeActionsTableViewController.swift`](./SwipeActionsTableViewController.swift) | You need swipe-to-delete / swipe actions. |
| [`DiffableTableViewController.swift`](./DiffableTableViewController.swift) | Modern apps — animated, crash-free updates (iOS 13+). |

## The 4 things every table needs

1. **A table view** added to the hierarchy (or subclass `UITableViewController`).
2. **A registered cell**: `tableView.register(Cell.self, forCellReuseIdentifier: id)`.
3. **A data source**: `numberOfRowsInSection` + `cellForRowAt`.
4. **A delegate** (optional): `didSelectRowAt`, swipe actions, heights.

## Step by step (basic list)

1. Create a `UITableViewController` subclass (or add a `UITableView` to a plain VC).
2. In `viewDidLoad`, register a cell class for a reuse identifier.
3. Return your row count from `tableView(_:numberOfRowsInSection:)`.
4. Dequeue and configure a cell in `tableView(_:cellForRowAt:)`.
5. Handle taps in `tableView(_:didSelectRowAt:)`.

## Dequeue, don't allocate

Always reuse cells — never create a new cell per row. That's what `dequeueReusableCell` is for; it recycles off-screen cells so a 10,000-row list stays smooth.

```swift
let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath) as! Cell
```

## Modern cell content (iOS 14+)

Prefer `UIListContentConfiguration` over the deprecated `textLabel`/`detailTextLabel`:

```swift
var content = cell.defaultContentConfiguration()
content.text = "Title"
content.secondaryText = "Subtitle"
content.image = UIImage(systemName: "star")
cell.contentConfiguration = content
```
