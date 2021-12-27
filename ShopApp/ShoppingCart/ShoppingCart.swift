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
        VStack {
            ShoppingCartListView(items: ivm.cartItems)
            PaymentButton()
                .scaledToFit()
                .padding()
        }
    }
}

struct ShoppingCart_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCart(ivm: ItemViewModel())
    }
}
