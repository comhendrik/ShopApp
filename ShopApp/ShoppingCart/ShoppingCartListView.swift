//
//  ShoppingCartListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCartListView: View {
    @StateObject var uvm: UserViewModel
    @Binding var showEditView: Bool
    var body: some View {
        ScrollView {
            ForEach(uvm.cartItems) { cartitem in
                CartMiniViewer(item: cartitem,
                               deleteAction: {
                    uvm.deleteCartItem(with: cartitem.id)
                },
                               editAction: {
                    uvm.placeholderCartItem = cartitem
                    withAnimation() {
                        showEditView.toggle()
                    }
                }, addAction: { number in
                })
            }

        }
    }
}


struct ShoppingCartListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartListView(uvm: UserViewModel(), showEditView: .constant(true))
    }
}
