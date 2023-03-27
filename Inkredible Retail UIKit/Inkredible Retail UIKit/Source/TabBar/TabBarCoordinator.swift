import UIKit
import Combine

class TabBarCoordinator: NSObject, Coordinator, UITabBarControllerDelegate {
  var children: [Coordinator] = []
  
  var navigationController: UINavigationController
  var tabBarController: UITabBarController
  
  /// The current page the tab bar has selected
  var currentPage: TabBarPage? {
    TabBarPage(index: tabBarController.selectedIndex)
  }
  
  private var subscriptions: Set<AnyCancellable> = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.tabBarController = UITabBarController()
  }
  
  func start() {
    let pages = TabBarPage.allCases.sorted
    let controllers: [UINavigationController] = pages.map(makeController(_:))
    
    prepare(with: controllers)
    
    // Sink to update the badge on the Cart Tab
    Cart.shared.$count
      .sink { [weak tabBarController] count in
        guard let item = tabBarController?.tabBar.items?[TabBarPage.cart.order] else { return }
        
        item.badgeValue = count > 0 ? count.formatted() : nil
      }.store(in: &subscriptions)
  }
  
  /// Selects a  page in the tab bar
  func selectPage(_ page: TabBarPage) {
    tabBarController.selectedIndex = page.order
  }
  
  /// Selects a  page in the tab bar by index
  func setSelectedIndex(_ index: Int) {
    guard let page = TabBarPage(index: index) else { return }
    
    tabBarController.selectedIndex = page.order
  }
}

private extension TabBarCoordinator {
  func makeController(_ page: TabBarPage) -> UINavigationController {
    let navController = makeNavController()
    
    navController.tabBarItem = UITabBarItem(
      title: page.title,
      image: UIImage(systemName: page.imageName),
      tag: page.order
    )
    
    switch page {
    case .catalog:
      let coordinator = CatalogCoordinator(navigationController: navController)
      coordinator.start()
      children.append(coordinator)
      
    case .cart:
      let coordinator = CartCoordinator(navigationController: navController)
      coordinator.start()
      children.append(coordinator)
    }
    
    return navController
  }
  
  func makeNavController() -> UINavigationController {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = UIColor.systemBlue
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    let proxy = UINavigationBar.appearance()
    proxy.tintColor = UIColor.white
    proxy.standardAppearance = appearance
    proxy.scrollEdgeAppearance = appearance
    
    // Setup our navigation controller and setup the appearance
    
    let navController = UINavigationController()
    navController.navigationBar.standardAppearance = appearance
    navController.navigationBar.scrollEdgeAppearance = appearance
    
    return navController
  }
  
  func prepare(with controllers: [UIViewController]) {
    tabBarController.delegate = self
    tabBarController.setViewControllers(controllers, animated: true)
    tabBarController.selectedIndex = 0
    
    navigationController.viewControllers = [tabBarController]
  }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
  }
}
