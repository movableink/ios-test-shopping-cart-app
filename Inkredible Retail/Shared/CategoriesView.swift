//
//  CategoriesView.swift
//  Inkredible Retail
//
//  Created by Movable Ink on 9/29/22.
//

import SwiftUI
import Combine
import MovableInk

enum CategorySection {
  case genders
  case categories(Product.Gender)
}

struct CategoriesView: View {
  @Environment(\.deeplink) var deeplink
  
  // Properties to handle search. By default, `searchable` does not debounce
  // the text, so we use `onChange(of: searchText)` to update  a publisher,
  // which debounces the response
  @State private var searchText = ""
  private let searchTextPublisher = PassthroughSubject<String, Never>()
  @State private var searchResults: [Product] = []
  
  @State private var path: [Deeplink] = []
  
  private var categories: [Product.Category] = Product.Category.allCases
  
  private let section: CategorySection
  private let onAddToCart: (Product) -> Void
  
  init(section: CategorySection, onAddToCart: @escaping (Product) -> Void) {
    self.section = section
    self.onAddToCart = onAddToCart
  }
  
  var body: some View {
    switch section {
    case .genders:
      NavigationStack(path: $path) {
        if searchResults.isEmpty {
          List(Product.Gender.allCases, id: \.rawValue) { gender in
            NavigationLink(gender.title, value: Deeplink.category(gender: gender))
          }
          .navigationDestination(for: Deeplink.self) { link in
            destination(for: link)
          }
        } else {
          List(searchResults, id: \.id) { product in
            NavigationLink(product.name, value: product)
          }
          .navigationDestination(for: Product.self) { product in
            ProductDetailView(
              product: product,
              onAddToCart: { product in
                onAddToCart(product)
              }
            )
          }
        }
      }
      .searchable(text: $searchText)
      .onChange(of: searchText) { newValue in
        searchTextPublisher.send(searchText)
      }
      .onChange(of: deeplink) { link in
        switch link {
        case let .category(gender):
          path.append(.category(gender: gender))
          
        case let .products(category):
          path.append(.products(category: category))
          
        case let .product(product):
          path.append(.product(product))
          
        case .none:
          break
        }
      }
      .onReceive(
        searchTextPublisher
          .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
          .receive(on: DispatchQueue.main)
      ) { query in
        if query.isEmpty {
          searchResults = []
        } else {
          searchResults = Product.mock.filter { $0.name.contains(searchText) }
          
          MIClient.productSearched(properties: .init(query: query))
        }
      }
      
    case .categories(let gender):
      List(Product.categoriesForGender(gender), id: \.rawValue) { category in
        NavigationLink(category.title, value: Deeplink.products(category: category))
      }
      .navigationDestination(for: Deeplink.self) { link in
        destination(for: link)
      }
    }
  }
  
  @ViewBuilder
  func destination(for deeplink: Deeplink) -> some View {
    switch deeplink {
    case let .category(gender):
      CategoriesView(
        section: .categories(gender),
        onAddToCart: onAddToCart
      )
      .navigationTitle(gender.title)
      .onAppear {
        MIClient.categoryViewed(
          category: .init(
            id: gender.title,
            url: gender.url
          )
        )
      }
      
    case let .products(category):
      ProductsView(
        category: category,
        onAddToCart: onAddToCart
      )
      .navigationTitle(category.title)
      .onAppear {
        MIClient.categoryViewed(
          category: .init(
            id: category.title,
            url: category.url
          )
        )
      }
      
    case let .product(product):
      ProductDetailView(
        product: product,
        onAddToCart: { product in
          onAddToCart(product)
        }
      )
    }
  }
}

struct CategoriesView_Previews: PreviewProvider {
  static var previews: some View {
    CategoriesView(section: .genders, onAddToCart: { _ in })
  }
}
