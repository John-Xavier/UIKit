import UIKit

// A fully-annotated scene delegate showing what belongs in each lifecycle phase.
final class SceneLifecycleDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Scene is being created. Build your UI here.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: UIViewController())
        window.makeKeyAndVisible()
        self.window = window
    }

    // ACTIVE: on screen and receiving events. Resume everything.
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("→ Active: resume timers, restart video, refresh data")
    }

    // INACTIVE (leaving Active): a call came in, control center, app switcher.
    func sceneWillResignActive(_ scene: UIScene) {
        print("→ Inactive: pause timers/animations, hide sensitive content")
        // e.g. add a blur overlay so secrets don't show in the app switcher.
    }

    // Coming back to the foreground (before Active).
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("→ Foreground: undo background prep, prefetch fresh data")
    }

    // BACKGROUND: off screen. THIS is your last reliable chance to save.
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("→ Background: SAVE STATE, release heavy resources, schedule bg tasks")
        // CoreDataStack.shared.saveContext()
        // BackgroundScheduler.scheduleAppRefresh()
    }

    // Scene is being released by the system. Clean up scene-scoped resources.
    func sceneDidDisconnect(_ scene: UIScene) {
        print("→ Disconnected: release scene-specific resources")
    }
}
