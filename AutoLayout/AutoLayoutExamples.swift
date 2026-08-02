import UIKit

// Copy-paste layout recipes you'll use constantly.
enum AutoLayoutExamples {

    // Pin a subview to fill its parent (edge to edge).
    static func pinToEdges(_ child: UIView, in parent: UIView, insets: UIEdgeInsets = .zero) {
        child.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(child)
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -insets.right),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom)
        ])
    }

    // Pin a subview to the safe area (below the notch, above the home indicator).
    static func pinToSafeArea(_ child: UIView, in parent: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(child)
        let guide = parent.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: guide.topAnchor),
            child.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            child.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

    // Center a fixed-size view.
    static func center(_ child: UIView, in parent: UIView, size: CGSize) {
        child.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(child)
        NSLayoutConstraint.activate([
            child.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            child.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
            child.widthAnchor.constraint(equalToConstant: size.width),
            child.heightAnchor.constraint(equalToConstant: size.height)
        ])
    }

    // A vertical form built with a stack view — no per-view constraints needed.
    static func makeForm() -> UIStackView {
        let title = UILabel()
        title.text = "Sign in"
        title.font = .preferredFont(forTextStyle: .largeTitle)

        let email = UITextField()
        email.placeholder = "Email"
        email.borderStyle = .roundedRect

        let password = UITextField()
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect

        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)

        let stack = UIStackView(arrangedSubviews: [title, email, password, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}
