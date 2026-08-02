import UIKit

// Drives a table of CustomCell rows from a simple model.
final class CustomCellTableViewController: UITableViewController {

    struct Contact {
        let name: String
        let role: String
        let unread: Int
    }

    private let contacts: [Contact] = [
        Contact(name: "Ada Lovelace", role: "Engineer", unread: 3),
        Contact(name: "Alan Turing", role: "Mathematician", unread: 0),
        Contact(name: "Grace Hopper", role: "Rear Admiral", unread: 12)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseID)
        tableView.rowHeight = 64
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomCell.reuseID, for: indexPath) as! CustomCell
        let contact = contacts[indexPath.row]
        cell.configure(title: contact.name, subtitle: contact.role, badge: contact.unread)
        return cell
    }
}
