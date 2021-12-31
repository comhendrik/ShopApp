//
//  ShoppingCart.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCart: View {
    @StateObject var ivm: ItemViewModel
    var body: some View {
        NavigationView {
            VStack {
                ShoppingCartListView(items: ivm.cartItems)
                HStack {
                    Text("Sum:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(String(format: "%.2f", calculateCost(items: ivm.cartItems)))$")
                    
                }
                .padding(.horizontal)
                PaymentButton()
                    .scaledToFit()
                    .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    private func calculateCost(items: [CartItem]) -> Double {
        var cost = 0.0
        for item in items {
            if item.item.discount == 0 {
                cost += item.item.price
            } else {
                cost += item.item.price - (item.item.price/100.0) * Double(item.item.discount)
            }
            
        }
        return cost
    }
}


struct ShoppingCart_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCart(ivm: ItemViewModel())
    }
}
