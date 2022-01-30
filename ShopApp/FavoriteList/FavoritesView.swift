//
//  FavoritesView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var uvm: UserViewModel
    @State private var showAddToCartView = false
    var body: some View {
        NavigationView {
            ZStack {
                if uvm.favoriteItems.count > 0 {
                    ScrollView {
                        ForEach(uvm.favoriteItems) { favoriteitem in
                            FavoriteMiniViewer(item: favoriteitem, uvm: uvm, showAddToCartView: $showAddToCartView,
                                deleteAction: {id in uvm.deleteFavoriteItem(with: id)})
                        }
                    }
                    .padding(.horizontal,10)
                    .blur(radius: showAddToCartView ? 3 : 0)
                } else {
                    VStack {
                        Spacer()
                        Text("Empty list")
                            .font(.title3)
                        Image(systemName: "heart.fill")
                            .font(.largeTitle)
                        Spacer()
                    }
                }
                VStack {
                    Spacer()
                    AddToCartView(uvm: uvm, showAddToCartView: $showAddToCartView,
                                  addAction: { id,amount, size in
                                       return uvm.addItemToCart(with: id, size: size, amount: amount)
                    }, item: uvm.placeholderItem)

                }
                .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                    Button("Ok", role: .cancel) {}
                }
                .offset(y: showAddToCartView ? -20 : 400)
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("Favorites")
                            .font(.title)
                            .fontWeight(.bold)
                        Image(systemName: "heart")
                            .font(.title)
                    }
                }
            }
            
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(uvm: UserViewModel())
    }
}
