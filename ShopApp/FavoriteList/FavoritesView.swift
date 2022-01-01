//
//  FavoritesView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct FavoritesView: View {
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
                    ForEach(ivm.favoriteItems) { favoriteitem in
                        FavoriteMiniViewer(item: favoriteitem, ivm: ivm, addToCartAction: {
                            ivm.placeholderItem = favoriteitem
                            withAnimation() {
                                showAddToCartView.toggle()
                            }
                        })
                    }
                }
                .blur(radius: showAddToCartView ? 5 : 0)
                VStack {
                    Spacer()
                    AddToCartView(ivm: ivm, showAddToCartView: $showAddToCartView, item: ivm.placeholderItem)
                }
                .offset(y: showAddToCartView ? -20 : 400)
            }
            .navigationBarHidden(true)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(ivm: ItemViewModel())
    }
}
