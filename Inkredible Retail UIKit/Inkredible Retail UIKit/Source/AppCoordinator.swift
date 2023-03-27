import UIKit

protocol Coordinator: AnyObject {
  var children: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }
  
  func start()
}

extension Coordinator {
  func childDidFinish(_ child: Coordinator?) {
    for (index, coordinator) in children.enumerated() where coordinator === child {
      children.remove(at: index)
      break
    }
  }
}

final class AppCoordinator: NSObject, Coordinator {
  var children: [Coordinator] = []
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.navigationController.setNavigationBarHidden(true, animated: true)
  }
  
  func start() {
    let coordinator = TabBarCoordinator(navigationController: navigationController)
    coordinator.start()
    children.append(coordinator)
  }
}
