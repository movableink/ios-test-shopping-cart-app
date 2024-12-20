import SwiftUI

@main
struct InAppMessagingSalesforceApp: App {
  init() {
    _ = SalesforceClient.shared
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
