//
//  FavoritesView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var uvm: UserViewModel
    @StateObject var ivm: ItemViewModel
    @State private var showAddToCartView = false
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    HStack {
                        Image(systemName: "heart")
                            .font(.largeTitle)
                            .padding()
                        Spacer()
                    }
                    ForEach(uvm.favoriteItems) { favoriteitem in
                        FavoriteMiniViewer(item: favoriteitem, uvm: uvm, showAddToCartView: $showAddToCartView, addToCartAction: { size in ivm.addItemToCart(with: favoriteitem.id, size: size)}, deleteAction: {id in ivm.deleteFavoriteItem(with: id)})
                    }
                }
                .blur(radius: showAddToCartView ? 5 : 0)
                VStack {
                    Spacer()
                    AddToCartView(uvm: uvm, showAddToCartView: $showAddToCartView, addAction: {id, size in ivm.addItemToCart(with: id, size: size)}, item: uvm.placeholderItem)
                }
                .offset(y: showAddToCartView ? -20 : 400)
            }
            .navigationBarHidden(true)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(uvm: UserViewModel(), ivm: ItemViewModel())
    }
}
