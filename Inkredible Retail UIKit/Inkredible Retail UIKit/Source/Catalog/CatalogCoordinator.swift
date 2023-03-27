import UIKit
import Combine
import MovableInk

final class CatalogCoordinator: NSObject, Coordinator {
  var children: [Coordinator] = []
  
  var subscriptions = Set<AnyCancellable>()
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let controller = CatalogViewController(section: .genders)
    controller.coordinator = self
    navigationController.setViewControllers([controller], animated: false)
    
    // Start a sink on any deeplinks that we might be able to manage
    DeeplinkManager.shared.$link
      .receive(on: DispatchQueue.main)
      .sink { [weak self] deeplink in
        switch deeplink {
        case let .category(gender):
          self?.showCategories(for: gender)
          
        case let .products(category):
          self?.showProducts(in: category)
          
        case let .product(id):
          guard let product = Product.mock.first(where: { $0.id == id }) else { return }
          
          self?.showProduct(product)
          
        default: break
        }
      }.store(in: &subscriptions)
  }
  
  func showCategories(for gender: Product.Gender) {
    let controller = CatalogViewController(section: .categories(gender))
    controller.coordinator = self
    
    MIClient.categoryViewed(
      category: .init(
        id: gender.title,
        url: gender.url
      )
    )
    
    navigationController.pushViewController(controller, animated: true)
  }
  
  func showProducts(in category: Product.Category) {
    let controller = ProductsViewController(category: category)
    controller.coordinator = self
    
    MIClient.categoryViewed(
      category: .init(
        id: category.title,
        url: category.url
      )
    )
    
    navigationController.pushViewController(controller, animated: true)
  }
  
  func showProduct(_ product: Product) {
    let controller = ProductDetailsViewController(product: product)
    controller.coordinator = self
    navigationController.pushViewController(controller, animated: true)
    
    MIClient.productViewed(
      properties: .init(
        id: product.id,
        title: product.name,
        price: product.formattedPrice,
        url: product.url,
        categories: [
          ProductCategory(id: product.gender.title, url: product.gender.url),
          ProductCategory(id: product.category.title, url: product.category.url)
        ],
        meta: nil
      )
    )
  }
}
