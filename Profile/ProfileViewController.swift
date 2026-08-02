import UIKit

// A profile screen: ProfileHeaderView on top of a grouped settings table.
final class ProfileViewController: UIViewController {

    private struct Row { let title: String; let icon: String; let isDestructive: Bool
        init(_ title: String, _ icon: String, destructive: Bool = false) {
            self.title = title; self.icon = icon; self.isDestructive = destructive
        }
    }

    private let sections: [[Row]] = [
        [Row("Edit Profile", "pencil"), Row("Notifications", "bell"), Row("Privacy", "lock")],
        [Row("Help", "questionmark.circle"), Row("About", "info.circle")],
        [Row("Log Out", "arrow.right.square", destructive: true)]
    ]

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let header = ProfileHeaderView()
    private static let cellID = "ProfileCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemGroupedBackground

        header.configure(name: "Jane Appleseed", posts: 42, followers: 1280, following: 310)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellID)
        tableView.tableHeaderView = header
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // tableHeaderView needs manual sizing (see README).
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let header = tableView.tableHeaderView else { return }
        let target = CGSize(width: tableView.bounds.width,
                            height: UIView.layoutFittingCompressedSize.height)
        let height = header.systemLayoutSizeFitting(
            target, withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel).height
        if header.frame.height != height {
            header.frame.size.height = height
            tableView.tableHeaderView = header
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath)
        let row = sections[indexPath.section][indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = row.title
        content.image = UIImage(systemName: row.icon)
        if row.isDestructive {
            content.textProperties.color = .systemRed
            content.imageProperties.tintColor = .systemRed
        }
        cell.contentConfiguration = content
        cell.accessoryType = row.isDestructive ? .none : .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped: \(sections[indexPath.section][indexPath.row].title)")
    }
}
