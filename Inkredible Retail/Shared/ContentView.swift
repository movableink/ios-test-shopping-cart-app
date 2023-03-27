//
//  ContentView.swift
//  Shared
//
//  Created by Movable Ink on 8/1/22.
//

import SwiftUI
import Combine
import MovableInk

enum ActiveTab: Hashable {
  case catalog
  case cart
}

struct ContentView: View {
  @Environment(\.deeplink) var deeplink
  
  @State var activeTab = ActiveTab.catalog
  
  @StateObject var cartState = SharedCartState()
  @Environment(\.scenePhase) var scenePhase
  @State var showingBuyConfirmation = false
  
  var body: some View {
    TabView(selection: $activeTab) {
      CategoriesView(
        section: .genders,
        onAddToCart: { product in
          cartState.cart.append(product)
          
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
      )
      .tabItem {
        VStack {
          Image(systemName: "book.fill")
          Text("Catalog")
        }
      }
      .tag(ActiveTab.catalog)
      
      CartView(
        cartState: cartState,
        onCheckout: {
          var productsForEvent: [OrderCompletedProduct] = []
          
          for product in cartState.cart {
            let value = OrderCompletedProduct(
              id: product.id,
              title: product.name,
              price: product.formattedPrice,
              url: product.url,
              quantity: 1
            )
            
            productsForEvent.append(value)
          }
          
          MIClient.orderCompleted(
            properties: .init(
              id: UUID().uuidString,
              revenue: cartState.total,
              products: productsForEvent
            )
          )
          
          cartState.cart = []
          showingBuyConfirmation = true
        },
        onRemoveFromCart: { product in
          cartState.cart = cartState.cart.filter { $0.id != product.id }
        }
      )
      .badge(cartState.cart.count)
      .tabItem {
        VStack {
          Image(systemName: "cart.fill")
          Text("Cart")
        }
      }
      .tag(ActiveTab.cart)
    }
    .font(.headline)
    .onChange(of: scenePhase) { newPhase in
      if newPhase == .background {
        print("\(priceFromCart(cartState.cart)) left in cart")
      }
    }
    .alert("Thank you for your patronage, please expect your items to arrive in 6-8 weeks", isPresented: $showingBuyConfirmation) {
      Button("Ok", role: .cancel) {
        showingBuyConfirmation = false
      }
    }
    .onChange(of: deeplink) { link in
      switch (link) {
      case .category, .products, .product:
        // Here we'll only change tabs to the catalog
        // The CategoriesView (catalog) will handle the navigation to the correct screen
        activeTab = .catalog
        
      case .none:
        break
      }
    }
  }
}

class SharedCartState: ObservableObject {
  @Published var cart: [Product] = []
  @Published private(set) var total: String = "$0.00"
  
  private var subscriptions: Set<AnyCancellable> = []
  
  init(cart: [Product] = []) {
    self.cart = cart
    
    $cart.sink { [weak self] cart in
      self?.total = priceFromCart(cart)
    }.store(in: &subscriptions)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
