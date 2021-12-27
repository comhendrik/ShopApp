//
//  ShoppingCartListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCartListView: View {
    var items: [Item]
    var body: some View {
        List(items) { item in
            Text(item.title)
        }
    }
}
//TODO: add preview items
//struct ShoppingCartListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShoppingCartListView(items: <#[Item]#>)
//    }
//}
