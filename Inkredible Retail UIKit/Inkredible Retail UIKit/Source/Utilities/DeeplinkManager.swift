import Foundation

enum DeeplinkPath: String, CaseIterable {
  case product = "\\b/?product/\\w+/?" // ends with /product/:id
  case category = "\\b/?category/\\w+/?" // ends with /category/:category
  case subCategory = "\\b/?category/\\w+/(\\w|-)+/?" // ends with /category/:category/:subcategory
  
  static func path(url: URL) -> DeeplinkPath? {
    let stringValue = url.absoluteString
    
    return DeeplinkPath.allCases.first {
      stringValue.contains($0.rawValue) ||
      (stringValue.range(of: $0.rawValue, options: .regularExpression) != nil)
    }
  }
}

enum Deeplink {
  case product(id: String)
  case category(gender: Product.Gender)
  case products(category: Product.Category)
}

class DeeplinkManager {
  static let shared = DeeplinkManager()
  
  /// The deeplink that needs to be handled.
  ///
  /// Create a sink in places where you'd perform the navigation to a given controller.
  @Published private(set) var link: Deeplink?
  
  private init() {}
  
  /// Publishes a Deeplink that parts of the app subscribes to which will open the corresponding screen for a given link
  ///
  /// - Parameter url: The URL that opened the app
  /// - Returns: True if we were able to handle the link, otherwise false
  @discardableResult static func route(to url: URL) -> Bool {
    switch DeeplinkPath.path(url: url) {
    case .product:
      // Grabs the ID parameter
      guard let id = url.pathComponents.last else {
        return false
      }
      
      shared.link = .product(id: id)
      
      return true
      
    case .category:
      // Grabs the gender parameter
      guard let id = url.pathComponents.last,
            let gender = Product.Gender.from(deeplinkID: id)
      else {
        return false
      }
      
      shared.link = .category(gender: gender)
      
      return true
      
    case .subCategory:
      // Grabs the subcategory parameter
      guard let id = url.pathComponents.last,
            let category = Product.Category.from(deeplinkID: id)
      else {
        return false
      }
      
      shared.link = .products(category: category)
      
      return true
      
    case .none:
      return false
    }
  }
}
