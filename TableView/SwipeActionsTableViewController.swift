import UIKit

// Swipe-to-delete plus a custom trailing "Flag" action and a leading "Done" action.
final class SwipeActionsTableViewController: UITableViewController {

    private var tasks = ["Buy milk", "Call dentist", "Ship the build", "Water plants"]
    private static let cellID = "SwipeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = tasks[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }

    // MARK: - Trailing swipe (right → left): Delete + Flag

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, done in
            self?.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            done(true)
        }

        let flag = UIContextualAction(style: .normal, title: "Flag") { _, _, done in
            print("Flagged: \(self.tasks[indexPath.row])")
            done(true)
        }
        flag.backgroundColor = .systemOrange
        flag.image = UIImage(systemName: "flag.fill")

        return UISwipeActionsConfiguration(actions: [delete, flag])
    }

    // MARK: - Leading swipe (left → right): Done

    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let done = UIContextualAction(style: .normal, title: "Done") { _, _, complete in
            print("Completed: \(self.tasks[indexPath.row])")
            complete(true)
        }
        done.backgroundColor = .systemGreen
        done.image = UIImage(systemName: "checkmark.circle.fill")

        let config = UISwipeActionsConfiguration(actions: [done])
        config.performsFirstActionWithFullSwipe = true // full swipe triggers "Done"
        return config
    }
}
