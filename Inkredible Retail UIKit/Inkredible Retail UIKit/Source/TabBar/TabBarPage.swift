import UIKit

enum TabBarPage: CaseIterable {
  case catalog
  case cart
  
  var title: String {
    switch self {
    case .catalog: return "Catalog"
    case .cart: return "Cart"
    }
  }
  
  var order: Int {
    switch self {
    case .catalog: return 0
    case .cart: return 1
    }
  }
  
  var imageName: String {
    switch self {
    case .catalog: return "book.fill"
    case .cart: return "cart.fill"
    }
  }
  
  init?(index: Int) {
    switch index {
    case 0:
      self = .catalog
    case 1:
      self = .cart
    default:
      return nil
    }
  }
}

extension Sequence where Element == TabBarPage {
  var sorted: [TabBarPage] {
    sorted(by: { $0.order < $1.order })
  }
}
