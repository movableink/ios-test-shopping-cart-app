import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    
    let options: UNAuthorizationOptions = [.alert, .sound, .badge, .provisional]
    center.requestAuthorization(options: options) { granted, error in
      debugPrint("Is Push Notifications Granted: \(granted)")
    }
    
    UIApplication.shared.registerForRemoteNotifications()
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    SalesforceClient.shared.didRegisterForRemoteNotifications(with: deviceToken)
  }
  
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    _ = SalesforceClient.shared.handleRemoteNotification(userInfo: userInfo, completion: completionHandler)
  }
  
  // Handle notifications that arrive when a user taps on the notification
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
  
  // Handle notifications that arrive while the app is opened and in the foreground
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.list, .banner])
  }
}
