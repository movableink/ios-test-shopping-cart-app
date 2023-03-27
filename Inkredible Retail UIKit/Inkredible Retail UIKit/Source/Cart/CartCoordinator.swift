import UIKit
import MovableInk

final class CartCoordinator: NSObject, Coordinator {
  var children: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = CartViewController()
    vc.coordinator = self
    navigationController.setViewControllers([vc], animated: false)
  }
  
  func showAskBuyNowAlert() {
    let message = "Are you sure you want to buy these products totaling \(Cart.shared.totalFormatted)"
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    alert.addAction(
      .init(title: "Purchase", style: .destructive, handler: { [unowned self] _ in
        self.purchase()
      })
    )
    
    alert.addAction(.init(title: "Cancel", style: .cancel))
    
    navigationController.present(alert, animated: true)
  }
  
  private func purchase() {
    var productsForEvent: [OrderCompletedProduct] = []
    
    for product in Cart.shared.products {
      let value = OrderCompletedProduct(
        id: product.id,
        title: product.name,
        price: product.formattedPrice,
        url: product.url,
        quantity: Cart.shared.items[product]
      )
      
      productsForEvent.append(value)
    }
    
    MIClient.orderCompleted(
      properties: .init(
        id: UUID().uuidString,
        revenue: Cart.shared.total / 100, // Cart total is stored in cents; the Order Completed event wants in dollars
        products: productsForEvent
      )
    )
    
    Cart.shared.clean()
    showPurchasedAlert()
  }
  
  func showPurchasedAlert() {
    let message = "Please expect your items to arrive in 6-8 weeks"
    let alert = UIAlertController(title: "Thank you", message: message, preferredStyle: .alert)
    
    alert.addAction(.init(title: "Ok", style: .cancel))
    
    navigationController.present(alert, animated: true)
  }
}
