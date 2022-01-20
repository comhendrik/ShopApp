//
//  ShoppingCartListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCartListView: View {
    @StateObject var uvm: UserViewModel
    var body: some View {
        ScrollView {
            ForEach(uvm.cartItems) { cartitem in
                CartMiniViewer(cartItem: cartitem, uvm: uvm)
            }

        }
    }
}


struct ShoppingCartListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartListView(uvm: UserViewModel())
    }
}
