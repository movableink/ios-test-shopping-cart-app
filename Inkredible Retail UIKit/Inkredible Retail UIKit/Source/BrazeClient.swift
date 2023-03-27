import UIKit
import BrazeKit
import BrazeUI
import MovableInk

final class BrazeClient: BrazeInAppMessageUIDelegate, BrazeDelegate {
  typealias Notifications = Braze.Notifications
  
  static let shared: BrazeClient = .init()
  var braze: Braze?
  
  private init() {
    let configuration = Braze.Configuration(
      apiKey: "",
      endpoint: "sdk.iad-03.braze.com"
    )
    configuration.triggerMinimumTimeInterval = 1
    configuration.sessionTimeout = 1
    
    // Enable logging of general SDK information (e.g. user changes, etc.)
    configuration.logger.level = .disabled
    
    self.braze = Braze(configuration: configuration)
    self.braze?.enabled = true
    self.braze?.delegate = self
    
    let presenter = BrazeInAppMessageUI()
    presenter.delegate = self
    self.braze?.inAppMessagePresenter = presenter
  }
  
  func didRegisterForRemoteNotifications(with deviceToken: Data) {
    braze?.notifications.register(deviceToken: deviceToken)
  }
  
  func handleRemoteNotification(userInfo: [AnyHashable: Any], completion: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
    guard let braze = braze else { return false }
    
    return braze.notifications.handleBackgroundNotification(
      userInfo: userInfo,
      fetchCompletionHandler: completion
    )
  }
  
  func handleUserNotification(response: UNNotificationResponse, completion: @escaping () -> Void) -> Bool{
    guard let braze = braze else { return false }
    
    return braze.notifications.handleUserNotification(
      response: response,
      withCompletionHandler: completion
    )
  }
  
  func trigger() {
    braze?.logCustomEvent(name: "Testing")
  }
}

// MARK: - BrazeInAppMessageUIDelegate

extension BrazeClient {
  func inAppMessage(
    _ ui: BrazeInAppMessageUI,
    displayChoiceForMessage message: Braze.InAppMessage
  ) -> BrazeInAppMessageUI.DisplayChoice {
    .now
  }
}
