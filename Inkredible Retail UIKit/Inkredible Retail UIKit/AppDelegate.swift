import UIKit
import MovableInk
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    PushNotificationManager.shared.start()
    _ = BrazeClient.shared
    
    MIClient.enabledLogTypes = .all
    
    MIClient.start(launchOptions: launchOptions) { result in
      switch result {
      case let .success(url):
        guard let url = URL(string: url) else { return }
        DeeplinkManager.route(to: url)
        
      case let .failure(.failure(url, message)):
        debugPrint(url, message)
        
      case .failure:
        debugPrint("Some unknown error occurred while resolving a deeplink")
      
      }
    }
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    PushNotificationManager.shared.didRegisterForRemoteNotifications(with: deviceToken)
  }
  
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    if BrazeClient.shared.handleRemoteNotification(userInfo: userInfo, completion: completionHandler) {
      return
    }
      
    completionHandler(.noData)
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    
  }
}

