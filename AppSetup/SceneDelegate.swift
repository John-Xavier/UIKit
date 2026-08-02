import UIKit

// Programmatic app entry point — no storyboard required.
// Delete Main.storyboard and clear the "Main Interface" setting first (see README).

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        // The scene hands us a UIWindowScene; attach a UIWindow to it.
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        // Pick your root. A navigation controller is the most common starting point.
        let root = ViewController()
        window.rootViewController = UINavigationController(rootViewController: root)

        // Make it visible.
        window.makeKeyAndVisible()
        self.window = window
    }
}

// A minimal root controller so the project compiles out of the box.
final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"

        let label = UILabel()
        label.text = "Hello, UIKit 👋"
        label.font = .preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
