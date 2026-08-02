# Pull-to-Refresh & Pagination

The two things every scrolling list eventually needs: **swipe down to reload** and **load more as you reach the bottom** (infinite scroll).

## Files

- [`RefreshablePaginatedTableViewController.swift`](./RefreshablePaginatedTableViewController.swift) — both patterns in one table view.

## Pull-to-refresh (3 lines)

```swift
tableView.refreshControl = UIRefreshControl()
tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
// in refresh(): reload data, then tableView.refreshControl?.endRefreshing()
```

Always call **`endRefreshing()`** when the reload finishes (success *or* failure) or the spinner spins forever.

## Pagination (infinite scroll)

Two common triggers — pick one:

1. **`willDisplay` cell** (recommended): when the last row is about to appear, fetch the next page.
2. **`scrollViewDidScroll`**: when the scroll offset nears the bottom, fetch.

Key state to track:
- `currentPage` — which page you're on.
- `isLoading` — a guard so you don't fire the same fetch twice.
- `hasMore` — stop when the server returns an empty/short page.

## Step by step

1. Keep `items`, `currentPage = 1`, `isLoading = false`, `hasMore = true`.
2. On `willDisplay` for the last row, if `!isLoading && hasMore`, load the next page.
3. Append results, increment the page, set `hasMore` from the response size.
4. Show a spinner in the table **footer** while loading more.
5. For refresh, reset to page 1 and replace (don't append) the data.
