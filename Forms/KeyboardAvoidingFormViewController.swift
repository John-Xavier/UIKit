import UIKit

// A scrollable form (scroll view + stack view) that avoids the keyboard,
// dismisses on tap, and chains fields via the Return key.
final class KeyboardAvoidingFormViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private lazy var nameField = makeField(placeholder: "Full name", content: .name)
    private lazy var emailField = makeField(placeholder: "Email", content: .emailAddress,
                                            keyboard: .emailAddress)
    private lazy var passwordField = makeField(placeholder: "Password", content: .password,
                                               secure: true, returnKey: .done)

    private lazy var submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Create account"
        config.cornerStyle = .medium
        let b = UIButton(configuration: config)
        b.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign up"
        view.backgroundColor = .systemBackground
        setupLayout()
        setupKeyboardHandling()
        setupFieldChaining()
    }

    // MARK: - Layout

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        [nameField, emailField, passwordField, submitButton].forEach {
            stackView.addArrangedSubview($0)
        }

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        let content = scrollView.contentLayoutGuide
        let frame = scrollView.frameLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Pin stack to the content guide (drives scrollable height).
            stackView.topAnchor.constraint(equalTo: content.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24),

            // Match width to the frame guide so it never scrolls horizontally.
            stackView.widthAnchor.constraint(equalTo: frame.widthAnchor, constant: -40)
        ])
    }

    // MARK: - Keyboard avoidance

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // Tap outside a field to dismiss.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func keyboardWillChange(_ note: Notification) {
        guard let value = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        let keyboardTop = value.cgRectValue.minY
        let overlap = max(0, view.bounds.height - keyboardTop)
        scrollView.contentInset.bottom = overlap
        scrollView.verticalScrollIndicatorInsets.bottom = overlap
    }

    // MARK: - Return-key chaining

    private func setupFieldChaining() {
        [nameField, emailField, passwordField].forEach { $0.delegate = self }
    }

    @objc private func submit() {
        view.endEditing(true)
        print("Submitting: \(emailField.text ?? "")")
    }

    // MARK: - Field factory

    private func makeField(placeholder: String,
                           content: UITextContentType,
                           keyboard: UIKeyboardType = .default,
                           secure: Bool = false,
                           returnKey: UIReturnKeyType = .next) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        tf.textContentType = content     // enables autofill
        tf.keyboardType = keyboard
        tf.isSecureTextEntry = secure
        tf.returnKeyType = returnKey
        tf.autocapitalizationType = (keyboard == .emailAddress) ? .none : .words
        return tf
    }
}

// MARK: - Move to the next field on Return.

extension KeyboardAvoidingFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField: emailField.becomeFirstResponder()
        case emailField: passwordField.becomeFirstResponder()
        default: submit()
        }
        return true
    }
}
