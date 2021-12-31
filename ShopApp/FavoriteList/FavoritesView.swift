//
//  FavoritesView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var ivm: ItemViewModel
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Image(systemName: "heart")
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                }
                ForEach(ivm.favoriteItems) { favoriteitem in
                    FavoriteMiniViewer(item: favoriteitem)
                }
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
