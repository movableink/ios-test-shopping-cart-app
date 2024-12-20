import UIKit
import WebKit

final private class FullScreenWKWebView: WKWebView {
  override var safeAreaInsets: UIEdgeInsets {
    UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}

final class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
  /// TRUE if the controller should act as an in app browser rather than an In App Message
  private let asInAppBrowser: Bool
  /// Set to true if you want to show a native close button in the top right of the web view
  private var showCloseButton: Bool {
    didSet {
      closeButton.isHidden = !showCloseButton
    }
  }
  /// The URL the controller was created with to display
  private var link: URL
  /// The handler to call when a link is interacted with and it has a buttonID
  private var handler: (String) -> Void
  
  private lazy var webView: FullScreenWKWebView = {
    var config = WKWebViewConfiguration()
    config.mediaTypesRequiringUserActionForPlayback = []
    config.allowsInlineMediaPlayback = true
    
    let view = FullScreenWKWebView(frame: .zero, configuration: config)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black
    view.alpha = 0
    
    return view
  }()
  
  /// Loading indicator while we're loading the page
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .large)
    view.startAnimating()
    return view
  }()
  
  private lazy var closeButton: UIButton = {
    var view: UIButton
    
    if #available(iOS 14.0, *) {
      view = UIButton(
        type: .close,
        primaryAction: .init(
          handler: { [weak self] _ in
            self?.dismissController()
          }
        )
      )
      
      view.tintColor = .red
      
    } else {
      view = UIButton()
      view.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
      view.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
      view.tintColor = .gray
    }
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: 45).isActive = true
    view.widthAnchor.constraint(equalToConstant: 45).isActive = true
    view.isHidden = !showCloseButton
    
    return view
  }()
  
  static func show(
    miLink: URL,
    asInAppBrowser: Bool = false,
    showCloseButton: Bool = false,
    handler: @escaping (String) -> Void
  ) {
    DispatchQueue.main.async {
      let controller = WebViewController(
        miLink: miLink,
        asInAppBrowser: asInAppBrowser,
        showCloseButton: showCloseButton,
        handler: handler
      )
      
      // If not acting as an InAppBrowser (Being an InAppMessage), be fullscreen
      if !asInAppBrowser {
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalPresentationCapturesStatusBarAppearance = true
      }
      
      UIApplication.keyWindow?.rootViewController?.present(controller, animated: true)
    }
  }
  
  private init(miLink: URL, asInAppBrowser: Bool, showCloseButton: Bool, handler: @escaping (String) -> Void) {
    self.link = miLink
    self.asInAppBrowser = asInAppBrowser
    self.showCloseButton = showCloseButton
    self.handler = handler
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    webView.navigationDelegate = self
    webView.uiDelegate = self
    
    view.backgroundColor = .black
    
    view.addSubview(webView)
    view.addSubview(closeButton)
    view.addSubview(activityIndicator)
    
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.topAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
    
    activityIndicator.center = view.center
  }
  
  override func viewDidLayoutSubviews() {
    var components = URLComponents(url: link, resolvingAgainstBaseURL: false)
    var queryItems = components?.queryItems ?? []
    // Older versions of the In App Package in Studio needed to know the viewport to render correctly
    // Uncomment this if you are using one of those versions
    //
    // queryItems.append(.init(name: "mi_viewport_width", value: "\(webView.frame.width)"))
    // queryItems.append(.init(name: "mi_viewport_height", value: "\(webView.frame.height)"))
    
    // If the link doesn't already contain the users mi_u value, you can add it here
    //
    // queryItems.append(.init(name: "mi_u", value: MIU))
    
    // Add the inline param to tell ourselves to handle this in app and not in Safari
    queryItems.append(.init(name: "inFrame", value: nil))
    
    components?.queryItems = queryItems
    
    // Make sure we have a valid URL, otherwise dismiss
    guard let url = URL(string: components?.string ?? link.absoluteString) else {
      dismiss(animated: true)
      return
    }
    
    // Check if showCloseButton was added as an query param on the link
    if queryItems.first(where: { $0.name == "showCloseButton" }) != nil {
      showCloseButton = true
    }
    
    // Load the page
    let request = URLRequest(url: url)
    self.webView.load(request)
  }
  
  @objc func dismissController() {
    dismiss(animated: true)
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    UIView.animate(withDuration: 0.25, animations: {
      self.webView.alpha = 1
      self.activityIndicator.stopAnimating()
    })
  }
  
  func webView(
    _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
  ) {
    guard let url = navigationAction.request.url else { decisionHandler(.allow); return }
    let components = URLComponents(string: url.absoluteString)
    
    guard let scheme = url.scheme, scheme != "http" && scheme != "https" else {
      handleButtonID(from: components)
      
      if asInAppBrowser {
        decisionHandler(.allow)
        return
      }
      
      // Check to see if we should overwrite the current link
      if components?.queryItems?.contains(where: { $0.name == "inFrame" }) ?? false {
        decisionHandler(.allow)
        return
      }
      
      // Check to see if we should open an in-app browser
      if components?.queryItems?.contains(where: { $0.name == "inAppBrowser" }) ?? false {
        decisionHandler(.cancel)
        dismissController()
        WebViewController.show(miLink: url, asInAppBrowser: true, handler: handler)
        
        return
      }
      
      // Open in Safari - Default
      UIApplication.shared.open(url)
      decisionHandler(.cancel)
      return
    }
    
    switch scheme {
    case "dismiss":
      // Support ability to dismiss the controller from the IAM via a button click.
      // The link should be `dismiss://`
      // If you want to know about the dismiss via the handler, you can add a query param of `buttonID` or `analytics_identifier`
      handleButtonID(from: components)
      dismissController()
      decisionHandler(.cancel)
      
    default:
      // Handle app schema links to allow you to deeplink from the IAM into the app
      UIApplication.shared.open(url)
      handleButtonID(from: components)
      dismissController()
      decisionHandler(.cancel)
    }
  }
  
  /// If a link is tapped in the IAM that has either a query param of `buttonID` or `analytics_identifier`, we call the handler to notify you
  private func handleButtonID(from components: URLComponents?) {
    if let item = components?.queryItems?.first(where: { $0.name == "buttonID" }), let value = item.value {
      handler(value)
    }
    
    if let item = components?.queryItems?.first(where: { $0.name == "analytics_identifier" }), let value = item.value {
      handler(value)
    }
  }
}

private extension UIApplication {
  static var keyWindow: UIWindow? {
    let allScenes = UIApplication.shared.connectedScenes
    
    for scene in allScenes {
      guard let windowScene = scene as? UIWindowScene else { continue }
      
      for window in windowScene.windows where window.isKeyWindow {
        return window
      }
    }
    
    return nil
  }
}
