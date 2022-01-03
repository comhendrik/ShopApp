//
//  ShoppingCartListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCartListView: View {
    @StateObject var uvm: UserViewModel
    @StateObject var ivm: ItemViewModel
    @Binding var showEditView: Bool
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "cart")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            ForEach(uvm.cartItems) { cartitem in
                CartMiniViewer(item: cartitem,
                               deleteAction: {
                    ivm.deleteCartItem(with: cartitem.id)
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


//TODO: add preview items
//struct ShoppingCartListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShoppingCartListView(items: [CartItem])
//    }
//}