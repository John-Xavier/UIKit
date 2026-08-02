import UIKit

// Grouped rows with section headers — e.g. a settings screen or an A–Z index.
final class SectionedTableViewController: UITableViewController {

    private struct Section {
        let title: String
        let rows: [String]
    }

    private let sections: [Section] = [
        Section(title: "Account", rows: ["Profile", "Password", "Subscriptions"]),
        Section(title: "Notifications", rows: ["Push", "Email", "Sounds"]),
        Section(title: "About", rows: ["Version", "Terms", "Privacy"])
    ]

    private static let cellID = "SectionCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)
    }

    // MARK: - Sections

    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    // MARK: - Rows

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = sections[indexPath.section].rows[indexPath.row]
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // Tip: use `UITableView(frame: .zero, style: .insetGrouped)` for the modern
    // rounded settings look. UITableViewController exposes `style` via its init.
}
