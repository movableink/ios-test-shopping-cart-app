import UIKit
import UserNotifications
import MovableInk

final class PushNotificationManager: NSObject, UNUserNotificationCenterDelegate {
  static let shared = PushNotificationManager()
  private override init() {
    super.init()
  }
  
  func start() {
    let center = UNUserNotificationCenter.current()
    center.setNotificationCategories(BrazeClient.Notifications.categories)
    center.delegate = self
    
    let options: UNAuthorizationOptions = [.alert, .sound, .badge, .provisional]
    center.requestAuthorization(options: options) { granted, error in
      
    }
    
    UIApplication.shared.registerForRemoteNotifications()
  }
  
  func didRegisterForRemoteNotifications(with deviceToken: Data) {
    BrazeClient.shared.didRegisterForRemoteNotifications(with: deviceToken)
  }
  
  // Handle notifications that arrive when a user taps on the notification
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if BrazeClient.shared.handleUserNotification(response: response, completion: completionHandler) {
      return
    }
    
    handleNotification(response.notification)
    
    completionHandler()
  }
  
  // Handle notifications that arrive while the app is opened and in the foreground
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Here we only want to show the banner in app, and only handle it if the user taps on it
    // Tapping on the notification will call userNotificationCenter(_:didReceive:withCompletionHandler:) for us
    completionHandler([.list, .banner])
  }
  
  private func handleNotification(_ notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    
    guard let aps = userInfo["aps"] as? [String: Any] else {
      return
    }
    
    /**
     {
         "aps": {
             "alert": {
                 "title": "Tap to see our new jacket!",
                 "body": "This is a test notification that should open a jacket page.",
                 "url": "https://www.movable-ink-7158.com/p/cpm/f9e1dde60c339938/c?url=https%3A%2F%2Fwww.movable-ink-7158.com%2Fp%2Frpm%2F4ff5ef609123c272%2Furl&url_sig=lyfxiiQP3n12CU"
             }
         }
     }
     */
    if let alert = aps["alert"] as? [String: Any],
        let urlString = alert["url"] as? String,
        let url = URL(string: urlString) {
      MIClient.handleUniversalLink(url: url)
    }
    
    /**
     {
         "aps": {
          "alert": {
             "title": "Hello, Notification!",
             "body": "This is a test notification that should open a jacket page."
          },
          "url": "https://www.movable-ink-7158.com/p/cpm/f9e1dde60c339938/c?url=https%3A%2F%2Fwww.movable-ink-7158.com%2Fp%2Frpm%2F4ff5ef609123c272%2Furl&url_sig=lyfxiiQP3n12CU"
         }
     }
     */
    if let urlString = aps["url"] as? String,
        let url = URL(string: urlString) {
      MIClient.handleUniversalLink(url: url)
    }
  }
}
