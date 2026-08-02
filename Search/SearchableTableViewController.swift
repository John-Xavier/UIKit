import UIKit

// A table filtered live via UISearchController, with scope buttons.
final class SearchableTableViewController: UITableViewController {

    private let allItems = [
        "Ada Lovelace", "Alan Turing", "Barbara Liskov", "Donald Knuth",
        "Edsger Dijkstra", "Grace Hopper", "John von Neumann", "Katherine Johnson",
        "Margaret Hamilton", "Tim Berners-Lee"
    ]
    private var filtered: [String] = []

    private let searchController = UISearchController(searchResultsController: nil)
    private static let cellID = "SearchCell"

    private var isSearching: Bool {
        searchController.isActive && !(searchController.searchBar.text ?? "").isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)
        configureSearch()
    }

    private func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search people"
        searchController.searchBar.scopeButtonTitles = ["All", "A–M", "N–Z"]
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true // dismiss search on push
    }

    private var activeItems: [String] { isSearching ? filtered : allItems }

    // MARK: - Data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activeItems.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = activeItems[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Filtering

extension SearchableTableViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        filter()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filter()
    }

    private func filter() {
        let query = searchController.searchBar.text?.lowercased() ?? ""
        let scope = searchController.searchBar.selectedScopeButtonIndex

        filtered = allItems.filter { name in
            let matchesQuery = query.isEmpty || name.lowercased().contains(query)
            let first = name.first.map { String($0).uppercased() } ?? ""
            let matchesScope: Bool
            switch scope {
            case 1: matchesScope = first <= "M"
            case 2: matchesScope = first >= "N"
            default: matchesScope = true
            }
            return matchesQuery && matchesScope
        }
        tableView.reloadData()
    }
}
