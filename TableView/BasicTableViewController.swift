import UIKit

// The simplest useful table view: a scrollable list of strings with tap handling.
final class BasicTableViewController: UITableViewController {

    // Your data. Swap this for a model array in a real app.
    private let items = ["Apples", "Bananas", "Cherries", "Dates", "Elderberries"]

    private static let cellID = "BasicCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fruits"

        // Register a stock cell for reuse.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)
    }

    // MARK: - Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath)

        // Modern content configuration (iOS 14+).
        var content = cell.defaultContentConfiguration()
        content.text = items[indexPath.row]
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // remove the grey highlight
        let picked = items[indexPath.row]
        print("Selected: \(picked)")
        // e.g. navigationController?.pushViewController(DetailViewController(item: picked), animated: true)
    }
}
