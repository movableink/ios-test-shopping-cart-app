import Foundation
import SwiftUI

enum DeeplinkPath: String, CaseIterable {
  case product = "\\b/product/\\w+/?" // ends with /product/:id
  case category = "\\b/category/\\w+/?" // ends with /category/:category
  case subCategory = "\\b/category/\\w+/(\\w|-)+/?" // ends with /category/:category/:subcategory
  
  static func path(url: URL) -> DeeplinkPath? {
    let stringValue = url.absoluteString
    
    return DeeplinkPath.allCases.first {
      stringValue.contains($0.rawValue) ||
      (stringValue.range(of: $0.rawValue, options: .regularExpression) != nil)
    }
  }
}

enum Deeplink: Hashable {
  case product(Product)
  case category(gender: Product.Gender)
  case products(category: Product.Category)
}

class DeeplinkManager {
  static let shared = DeeplinkManager()
  
  private init() {}
  
  /// Returns a Deeplink that should be navigated to.
  ///
  /// - Parameter url: The URL that opened the app
  /// - Returns: The Deeplink
  static func route(to url: URL) -> Deeplink? {
    switch DeeplinkPath.path(url: url) {
    case .product:
      // Grabs the ID parameter
      guard let id = url.pathComponents.last else { return nil }
      guard let product = Product.mock.first(where: { $0.id == id }) else { return nil }
      
      return .product(product)
      
    case .category:
      // Grabs the gender parameter
      guard let id = url.pathComponents.last,
            let gender = Product.Gender.from(deeplinkID: id)
      else {
        return nil
      }
      
      return .category(gender: gender)
      
    case .subCategory:
      // Grabs the subcategory parameter
      guard let id = url.pathComponents.last,
            let category = Product.Category.from(deeplinkID: id)
      else {
        return nil
      }
      
      return .products(category: category)
      
    case .none:
      return nil
    }
  }
}

struct DeeplinkKey: EnvironmentKey {
  static var defaultValue: Deeplink? {
    return nil
  }
}

// MARK: - Define a new environment value property

extension EnvironmentValues {
  var deeplink: Deeplink? {
    get {
      self[DeeplinkKey.self]
    }
    
    set {
      self[DeeplinkKey.self] = newValue
    }
  }
}
