import XCTest
@testable import Inkredible_Retail_UIKit

final class CartTests: XCTestCase {
  override func setUpWithError() throws {
    
  }
  
  override func tearDownWithError() throws {
    Cart.shared.clean()
  }
  
  func testAddToCart() throws {
    let product = Product.mock.first!
    let other = Product.mock.last!
    let qty = Int.random(in: 1...100)
    
    Cart.shared.add(product: product)
    Cart.shared.add(product: other, quantity: qty)
    
    XCTAssertEqual(Cart.shared.items[product], 1)
    XCTAssertEqual(Cart.shared.items[other], qty)
  }
  
  func testDecrementQuantity() throws {
    let product = Product.mock.first!
    let other = Product.mock.last!
    
    Cart.shared.add(product: product, quantity: 2)
    Cart.shared.add(product: other)
    
    Cart.shared.decrementQuantity(of: product)
    Cart.shared.decrementQuantity(of: other)
    
    XCTAssertEqual(Cart.shared.items[product], 1)
    XCTAssertEqual(Cart.shared.items[other], nil)
  }
  
  func testRemove() throws {
    let product = Product.mock.first!
    
    Cart.shared.add(product: product, quantity: 2)
    
    Cart.shared.remove(product: product)
    
    XCTAssertEqual(Cart.shared.items[product], nil)
  }
  
  func testTotal() throws {
    let product = Product.mock.first!
    let qty = Int.random(in: 1...100)
    
    Cart.shared.add(product: product, quantity: qty)
    
    let price = product.price * qty
    XCTAssertEqual(Cart.shared.total, price)
  }
  
  func testClean() throws {
    let product = Product.mock.first!
    let other = Product.mock.last!
    
    Cart.shared.add(product: product, quantity: 2)
    Cart.shared.add(product: other, quantity: 5)
    
    Cart.shared.clean()
    
    XCTAssertTrue(Cart.shared.items.isEmpty)
    XCTAssertEqual(Cart.shared.total, 0)
  }
}
