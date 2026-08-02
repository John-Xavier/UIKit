import UIKit

// A table with pull-to-refresh AND infinite-scroll pagination.
final class RefreshablePaginatedTableViewController: UITableViewController {

    private var items: [String] = []
    private var currentPage = 1
    private let pageSize = 20
    private var isLoading = false
    private var hasMore = true

    private static let cellID = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)

        // Pull-to-refresh.
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresh

        loadNextPage()
    }

    // MARK: - Data loading

    @objc private func handleRefresh() {
        currentPage = 1
        hasMore = true
        Task {
            let fresh = await fetchPage(1)
            items = fresh                       // replace, don't append
            currentPage = 2
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()   // ALWAYS stop the spinner
        }
    }

    private func loadNextPage() {
        guard !isLoading, hasMore else { return }
        isLoading = true
        showFooterSpinner(true)

        Task {
            let page = await fetchPage(currentPage)
            items.append(contentsOf: page)
            hasMore = page.count == pageSize    // short page => no more data
            currentPage += 1
            isLoading = false
            showFooterSpinner(false)
            tableView.reloadData()
        }
    }

    // Simulated network call. Swap for APIService in a real app.
    private func fetchPage(_ page: Int) async -> [String] {
        try? await Task.sleep(nanoseconds: 600_000_000) // fake latency
        let start = (page - 1) * pageSize
        return (start..<start + pageSize).map { "Item \($0 + 1)" }
    }

    // MARK: - Footer spinner

    private func showFooterSpinner(_ show: Bool) {
        guard show else { tableView.tableFooterView = nil; return }
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = spinner
    }

    // MARK: - Data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = items[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }

    // MARK: - Pagination trigger

    // Fetch the next page as the last row is about to appear.
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            loadNextPage()
        }
    }
}
