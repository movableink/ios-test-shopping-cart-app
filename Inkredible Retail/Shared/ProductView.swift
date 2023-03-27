//
//  ProductView.swift
//  Inkredible Retail
//
//  Created by Movable Ink on 8/19/22.
//

import Foundation
import SwiftUI
import MovableInk

struct ProductDetailView: View {
  let product: Product
  let onAddToCart: (Product) -> Void
  
  var body: some View {
    ScrollView {
      Image(product.imageName)
        .resizable()
        .frame(width: 150, height: 200, alignment: .bottom)
      
      Text(product.name)
        .font(.body)
      
      Button {
        onAddToCart(product)
      } label: {
        Text("Add to Cart")
          .frame(maxWidth: .infinity)
          .frame(height: 44)
          .foregroundColor(Color.white)
          .background(Color.blue)
          .cornerRadius(10)
      }
      .padding()
    }
    .onAppear {
      MIClient.productViewed(
        properties: .init(
          id: product.id,
          title: product.name,
          price: product.formattedPrice,
          url: URL(string: "https://movableink-inkredible-retail.herokuapp.com/product/\(product.id)"),
          categories: [
            ProductCategory(id: product.gender.title, url: product.gender.url),
            ProductCategory(id: product.category.title, url: product.category.url)
          ],
          meta: [:]
        )
      )
    }
  }
}
