import UIKit
import Combine

// Two-way binding between text fields and a FormViewModel using Combine.
final class CombineBindingViewController: UIViewController {

    private let viewModel = FormViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let messageLabel = UILabel()
    private let submitButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Combine Form"
        view.backgroundColor = .systemBackground
        setupViews()
        bind()
    }

    private func bind() {
        // FIELDS ──► VIEW MODEL
        emailField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)

        passwordField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)

        // VIEW MODEL ──► UI
        viewModel.$isValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] valid in
                self?.submitButton.isEnabled = valid
                self?.submitButton.alpha = valid ? 1 : 0.4
            }
            .store(in: &cancellables)

        viewModel.$validationMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: messageLabel)
            .store(in: &cancellables)
    }

    private func setupViews() {
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none

        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        messageLabel.font = .preferredFont(forTextStyle: .footnote)
        messageLabel.textColor = .systemRed
        messageLabel.numberOfLines = 0

        submitButton.setTitle("Submit", for: .normal)
        submitButton.isEnabled = false

        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, messageLabel, submitButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

// A small helper turning a UITextField's edits into a Combine publisher.
extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .prepend(text ?? "")   // emit the initial value too
            .eraseToAnyPublisher()
    }
}
