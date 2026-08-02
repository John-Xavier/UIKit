# Search — UISearchController

Add a search bar that filters a list, the standard iOS way. `UISearchController` integrates with the navigation bar and handles the presentation for you.

## Files

- [`SearchableTableViewController.swift`](./SearchableTableViewController.swift) — a table filtered live as you type, with scope buttons.

## Step by step

1. Create a `UISearchController(searchResultsController: nil)` — `nil` means "show results in the same table."
2. Set `searchController.searchResultsUpdater = self` and conform to `UISearchResultsUpdating`.
3. Attach it: `navigationItem.searchController = searchController`.
4. Keep two arrays: the full data and the `filtered` data. Point your data source at whichever is active.
5. In `updateSearchResults(for:)`, filter the full array by `searchController.searchBar.text` and `reloadData()`.

## Gotchas

- Set `navigationItem.hidesSearchBarWhenScrolling = false` if you want the bar always visible.
- Use `searchController.obscuresBackgroundDuringPresentation = false` when results show in the same table (otherwise the list dims).
- **Scope buttons** (All / Favorites / etc.) come from `searchBar.scopeButtonTitles`; read the selection in your filter.
