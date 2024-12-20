import Foundation
import MarketingCloudSDK

final class SalesforceClient: NSObject, InAppMessageEventDelegate {
  static let shared: SalesforceClient = .init()
  
  override init() {
    super.init()
    
    let appId = ""
    let accessToken = ""
    let appEndpoint = URL(string: "")!
    let mid = ""
    
    let mobilePushConfiguration = PushConfigBuilder(appId: appId)
      .setAccessToken(accessToken)
      .setMarketingCloudServerUrl(appEndpoint)
      .setMid(mid)
      .setInboxEnabled(false)
      .setLocationEnabled(false)
      .setAnalyticsEnabled(true)
      .build()
    
    let completionHandler: (OperationResult) -> () = { result in
      switch result {
      case .success:
        // module is fully configured and ready for use
        debugPrint(result)
        
        SFMCSdk.requestPushSdk { mp in
          mp.setEventDelegate(self)
        }
        
        break
        
      case .error, .cancelled, .timeout:
        debugPrint(result)
        break
        
      @unknown default:
        debugPrint(result)
        break
      }
    }
    
    SFMCSdk.initializeSdk(
      ConfigBuilder()
        .setPush(config: mobilePushConfiguration, onCompletion: completionHandler)
        .build()
    )
  }
}

// MARK: - SFMC InAppMessageEventDelegate

extension SalesforceClient {
  // Salesforce Marketing Cloud does not support HTML based In App Messages, so you'll need to extract the link to show the message.
  // You can still use SFMC's Journey Builder to decide when to show the message.
  //
  // In SFMC Content Builder, create a new Mobile App/In-App Message.
  // In the Content section, set the Title to mi_link:YOUR_LINK, for example, mi_link:https://mi.example.com/p/rp/12345.html
  //
  // In Journey Builder, create a new Journey to show the In App Message.
  //
  // Once your in app message is created, you can then extract the link to show it instead of the SFMC SDK.
  func sfmc_shouldShow(inAppMessage message: [AnyHashable : Any]) -> Bool {
    guard let title = message["title"] as? [AnyHashable: Any],
          let text = title["text"] as? String,
          text.hasPrefix("mi_link:")
    else {
      return true
    }
    
    let miLinkString = String(text.dropFirst("mi_link:".count))
    
    guard let miLink = URL(string: miLinkString) else { return false }
    
    SFMCSdk.requestPushSdk { mp in
      // let messageID = mp.messageId(forMessage: message)
    
      Task { @MainActor in
        WebViewController.show(miLink: miLink) { buttonID in
          // self?.logClick(miLink: miLink.absoluteString, buttonID: buttonID, messageID: messageID)
        }
      }
    }
    
    return false
  }
  
  // You can track custom events to SFMC or anywhere else if you need it from button clicks that occur in the IAM
  private func logClick(miLink: String, buttonID: String?, messageID: String?) {
    SFMCSdk.track(
      event: CustomEvent(
        name: "in_app_message_button_tapped",
        attributes: ["button_id": buttonID ?? "", "mi_link": miLink, "messageID": messageID ?? ""]
      )!
    )
  }
}
