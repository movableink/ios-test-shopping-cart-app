import SwiftUI
import MovableInk

@main
struct Inkredible_RetailApp: App {
  @State var deeplink: Deeplink?
  
  init() {
    MIClient.enabledLogTypes = .all
    
    MIClient.start { _ in }
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.deeplink, deeplink)
        .onOpenURL { url in
          if let deeplink = DeeplinkManager.route(to: url) {
            self.deeplink = deeplink
          }
          else if MIClient.handleUniversalLink(url: url) {
            return
          }
        }
        .onReceive(MIClient.storedDeeplinkSubject.receive(on: DispatchQueue.main)) { value in
          guard let value = value, let url = URL(string: value) else { return }
          
          self.deeplink = DeeplinkManager.route(to: url)
        }
    }
  }
}
