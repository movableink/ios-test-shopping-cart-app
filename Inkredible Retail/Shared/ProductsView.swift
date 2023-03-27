//
//  ProductsView.swift
//  Inkredible Retail
//
//  Created by Movable Ink on 8/16/22.
//

import SwiftUI

struct ProductThumbnail: View {
  let product: Product
  
  var body: some View {
    VStack(alignment: .center) {
      Image(product.imageName)
        .resizable()
        .frame(width: 150, height: 200, alignment: .bottom)
      
      Text(product.name)
        .font(.body)
        .foregroundColor(.black)
        .lineLimit(2)
        .multilineTextAlignment(.center)
    }
  }
}

struct ProductsView: View {
  let category: Product.Category
  let onAddToCart: (Product) -> Void
  
  @State private var currentProduct: Product? = nil
  @State private var showingSheet: Bool = false
  
  var currentProducts: [Product] {
    Product.mockedByCategory[category]!
  }
  
  var body: some View {
    ScrollView {
      Grid {
        ForEach(currentProducts.splitBy(subSize: 2), id: \.self) { group in
          GridRow {
            ForEach(group) { product in
              NavigationLink(
                destination: ProductDetailView(
                  product: product,
                  onAddToCart: onAddToCart
                )
                .navigationTitle("Product")
              ) {
                ProductThumbnail(product: product)
              }
            }
          }
        }
      }
      .sheet(isPresented: $showingSheet) {
        if let currentProduct = currentProduct {
          ProductDetailView(
            product: currentProduct,
            onAddToCart: { product in
              onAddToCart(product)
              showingSheet = false
            }
          )
        }
      }
    }
  }
}

struct ProductsView_Previews: PreviewProvider {
  static var previews: some View {
    ProductsView(
      category: .dressSuit,
      onAddToCart: { _ in }
    )
  }
}
