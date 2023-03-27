//
//  CartView.swift
//  Inkredible Retail
//
//  Created by Movable Ink on 8/16/22.
//

import SwiftUI

struct CartView: View {
  @ObservedObject var cartState: SharedCartState
  @State private var showingAlert = false
  
  private let onCheckout: () -> Void
  private let onRemoveFromCart: (Product) -> Void
  
  init(cartState: SharedCartState, onCheckout: @escaping () -> Void, onRemoveFromCart: @escaping (Product) -> Void) {
    self.cartState = cartState
    self.onCheckout = onCheckout
    self.onRemoveFromCart = onRemoveFromCart
  }
  
  private func delete(_ product: Product) {
    onRemoveFromCart(product)
  }
  
  private func delete(at offsets: IndexSet) {
    for offset in offsets {
      let item = cartState.cart[offset]
      onRemoveFromCart(item)
    }
  }
  
  var body: some View {
    VStack {
      if cartState.cart.isEmpty {
        Text("Cart is Empty :(")
      } else {
        Text("\(cartState.cart.count) item\(cartState.cart.count > 1 ? "s" : "") in cart")
        
       List {
           ForEach(cartState.cart) { product in
             HStack(alignment: .center) {
               Image(product.imageName)
                 .resizable()
                 .frame(width: 75, height: 100, alignment: .leading)
               
               VStack(alignment: .leading) {
                 Text(product.name)
                   .font(.body)
                 
                 Text(product.formattedPrice)
                   .font(.caption)
               }
             }
             .contextMenu {
               Button {
                 delete(product)
               } label: {
                 Label("Delete", systemImage: "trash")
               }
             }
           }
           .onDelete(perform: delete)
        }
        
        VStack(spacing: 0) {
          Text("Cart Total")
          
          Text(cartState.total)
            .frame(maxWidth: .infinity)
            .padding()
          
          Button {
            showingAlert = true
          } label: {
            Text("Buy Now")
              .frame(maxWidth: .infinity)
              .frame(height: 44)
              .foregroundColor(Color.white)
              .background(Color.blue)
              .cornerRadius(10)
          }
          .alert(
            "Are you sure you want to buy these products totaling \(cartState.total)?",
            isPresented: $showingAlert
          ) {
            Button("Buy", role: .destructive) {
              onCheckout()
            }
          }
          .padding(.horizontal, 16)
        }
      }
    }
  }
}

struct CartView_Previews: PreviewProvider {
  @StateObject static var empty = SharedCartState()
  @StateObject static var full = SharedCartState(cart: Product.mock)
  
  static var previews: some View {
    CartView(
      cartState: empty,
      onCheckout: {},
      onRemoveFromCart: { _ in }
    )
    
    CartView(
      cartState: full,
      onCheckout: {},
      onRemoveFromCart: { _ in }
    )
  }
}
