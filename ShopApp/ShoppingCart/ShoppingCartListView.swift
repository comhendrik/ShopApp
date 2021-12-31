//
//  ShoppingCartListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCartListView: View {
    var items: [CartItem]
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "cart")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            ForEach(items) { cartitem in
                CartMiniViewer(item: cartitem)
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
