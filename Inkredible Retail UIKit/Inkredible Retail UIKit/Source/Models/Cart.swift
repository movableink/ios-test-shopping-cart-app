import Foundation
import Combine
import OrderedCollections
import MovableInk

final class Cart {
  static let shared = Cart()
  
  /// A map of a product and the quantity of that product in the cart
  private(set) var items: [Product: Int] = [:]
  /// A list of products in the cart
  private(set) var products: OrderedSet<Product> = []
  
  /// The number of items in the cart.
  @Published var count: Int = 0
  
  /// The running total of the cart in cents.
  @Published var total: Int = 0
  
  var totalFormatted: String {
    (total / 100).formatted(.currency(code: "usd"))
  }
  
  private init() {}
  
  private func update() {
    // Updates self.total and self.count in the same reducer
    let calc = items.reduce((price: 0, count: 0)) { partialResult, next in
      let price = partialResult.price + (next.key.price * next.value)
      let count = partialResult.count + next.value
      
      return (price: price, count: count)
    }
    
    total = calc.price
    count = calc.count
  }
  
  /// Adds a product with the given quantity to the cart.
  func add(product: Product, quantity: Int = 1) {
    if items[product] != nil {
      let currentQuantity = items[product] ?? 0
      items[product] = currentQuantity + quantity
    } else {
      items[product] = quantity
    }
    
    products.append(product)
    
    update()
    
    MIClient.productAdded(
      properties: .init(
        id: product.id,
        title: product.name,
        price: product.formattedPrice,
        url: product.url,
        categories: [
          ProductCategory(id: product.gender.title, url: product.gender.url),
          ProductCategory(id: product.category.title, url: product.category.url)
        ],
        meta: [:]
      )
    )
  }
  
  /// Decrements the quantity of a product in the cart. If the quantity of a product reaches 0, it will be removed.
  func decrementQuantity(of product: Product) {
    if let quantity = items[product], quantity > 1 {
      items[product] = quantity - 1
    } else {
      remove(product: product)
    }
    
    update()
  }
  
  /// Removes a product from the cart in it's entirety.
  func remove(product: Product) {
    items[product] = nil
    products.remove(product)
    
    update()
  }
  
  /// Cleans the cart by removing all products
  func clean() {
    items = [:]
    products.removeAll()
    update()
  }
}
