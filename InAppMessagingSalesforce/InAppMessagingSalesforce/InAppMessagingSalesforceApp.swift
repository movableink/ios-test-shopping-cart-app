import SwiftUI

@main
struct InAppMessagingSalesforceApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {
    _ = SalesforceClient.shared
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
