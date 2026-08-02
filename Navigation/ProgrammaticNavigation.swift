import UIKit

// Demonstrates: forward data injection, backward result via closure, push & present.

// MARK: - A detail screen that receives data forward (via init).

final class DetailViewController: UIViewController {
    private let item: String

    init(item: String) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = item
    }
}

// MARK: - A picker that returns a result backward (via closure).

final class ColorPickerViewController: UIViewController {

    // The caller sets this; we call it when the user picks.
    var onPick: ((UIColor) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pick a color"

        let button = UIButton(type: .system)
        button.setTitle("Choose Red", for: .normal)
        button.addTarget(self, action: #selector(pickRed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func pickRed() {
        onPick?(.systemRed)      // hand the result back…
        dismiss(animated: true)  // …then close.
    }
}

// MARK: - The screen that navigates.

final class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Menu"
    }

    func openDetail() {
        // Forward: pass data in through the initializer.
        let detail = DetailViewController(item: "Selected item")
        navigationController?.pushViewController(detail, animated: true)
    }

    func openColorPicker() {
        // Backward: receive a result through a closure.
        let picker = ColorPickerViewController()
        picker.onPick = { [weak self] color in
            self?.view.backgroundColor = color
        }
        // Wrap in a nav controller so the modal has its own bar.
        present(UINavigationController(rootViewController: picker), animated: true)
    }
}
