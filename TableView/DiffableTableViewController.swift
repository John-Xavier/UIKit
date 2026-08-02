import UIKit

// Modern diffable data source (iOS 13+): you describe *what* the data is and
// UIKit animates the difference. No more manual insert/delete/reload bugs.
final class DiffableTableViewController: UITableViewController {

    // Sections must be Hashable.
    enum Section { case main }

    // Items must be Hashable. A struct with a stable id is ideal.
    struct Fruit: Hashable {
        let id = UUID()
        let name: String
    }

    private static let cellID = "DiffableCell"

    // The data source owns the table's content.
    private lazy var dataSource = makeDataSource()

    private var fruits = [
        Fruit(name: "Apple"), Fruit(name: "Banana"), Fruit(name: "Cherry")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Diffable"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addRandom))
        applySnapshot(animatingDifferences: false)
    }

    // MARK: - Data source

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Fruit> {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, fruit in
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = fruit.name
            cell.contentConfiguration = content
            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Fruit>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fruits, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    // MARK: - Mutations (just change the model, then re-apply)

    @objc private func addRandom() {
        let names = ["Mango", "Kiwi", "Peach", "Plum", "Fig", "Lime"]
        fruits.append(Fruit(name: names.randomElement()!))
        applySnapshot() // animated diff for free
    }

    // Swipe-to-delete still works — mutate the model and re-apply.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
              let fruit = dataSource.itemIdentifier(for: indexPath) else { return }
        fruits.removeAll { $0 == fruit }
        applySnapshot()
    }
}
