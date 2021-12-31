//
//  ContentView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var ivm = ItemViewModel()
    var body: some View {
        TabView {
            HomeView(ivm: ivm)
                .tabItem{
                    Image(systemName: "house")
                    Text("home")
                        .foregroundColor(.black)
                }
            ShoppingCart(ivm: ivm)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
            FavoritesView(ivm: ivm)
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("Favorites")
                }
            MapView()
                .tabItem {
                    Image(systemName: "map.circle")
                    Text("map")
                }
            AccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("account")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
