import UIKit

// Build a tab bar controller in code. Call makeTabBarController() from SceneDelegate.
func makeTabBarController() -> UITabBarController {

    let tabBar = UITabBarController()

    // Each tab is usually its own navigation stack.
    let home = UINavigationController(rootViewController: BasicTableViewController())
    home.tabBarItem = UITabBarItem(title: "Home",
                                   image: UIImage(systemName: "house"),
                                   selectedImage: UIImage(systemName: "house.fill"))

    let search = UINavigationController(rootViewController: SearchableTableViewController())
    search.tabBarItem = UITabBarItem(title: "Search",
                                     image: UIImage(systemName: "magnifyingglass"),
                                     selectedImage: nil)

    let profile = UINavigationController(rootViewController: ProfileViewController())
    profile.tabBarItem = UITabBarItem(title: "Profile",
                                      image: UIImage(systemName: "person"),
                                      selectedImage: UIImage(systemName: "person.fill"))

    tabBar.viewControllers = [home, search, profile]
    tabBar.tabBar.tintColor = .systemBlue
    return tabBar
}
