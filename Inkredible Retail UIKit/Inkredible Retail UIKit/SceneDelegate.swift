import UIKit
import MovableInk

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var coordinator: AppCoordinator?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    // Setup our navigation controller and init the AppCoordinator with it
    
    let navigationController = UINavigationController()
    
    coordinator = AppCoordinator(navigationController: navigationController)
    coordinator?.start()
    
    window = UIWindow(windowScene: scene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    MIClient.handleUniversalLink(with: connectionOptions)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      BrazeClient.shared.trigger()
    }
  }
  
  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    MIClient.handleUniversalLink(from: userActivity)
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    for context in URLContexts {
      if MIClient.handleUniversalLink(url: context.url) {
        break
      }
      
      // Ask the manager to route to that path in the app if it can
      guard DeeplinkManager.route(to: context.url) else { continue }
      
      // break out of the loop as we've found a url that we can handle
      break
    }
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
}
