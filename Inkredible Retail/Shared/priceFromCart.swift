//
//  priceFromCart.swift
//  Inkredible Retail
//
//  Created by Movable Ink on 9/9/22.
//

import Foundation

func priceFromCart(_ cart: [Product]) -> String {
  let totalPrice = Double(cart.reduce(0, { accum, next in accum + next.price })) / 100
  
  return totalPrice.formatted(.currency(code: "usd"))
}
