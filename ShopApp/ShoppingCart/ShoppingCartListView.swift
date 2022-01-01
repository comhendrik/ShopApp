//
//  ShoppingCartListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCartListView: View {
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
            ForEach(ivm.cartItems) { cartitem in
                CartMiniViewer(item: cartitem,
                               deleteAction: {
                    ivm.deleteCartItem(with: cartitem.id)
                },
                               editAction: {
                    ivm.placeholderCartItem = cartitem
                    withAnimation() {
                        showEditView.toggle()
                    }
                }, addAction: { number in
                    ivm.addCartItem(with: cartitem.item.id + String(number), size: number, item: cartitem.item)
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
