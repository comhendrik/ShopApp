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
        NavigationView {
            TabView {
                HomeView(ivm: ivm)
                    .tabItem{
                        Image(systemName: "house")
                        Text("home")
                    }
                ShoppingCart(ivm: ItemViewModel())
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Cart")
                    }
                FavoritesView()
                    .tabItem {
                        Image(systemName: "heart.text.square")
                        Text("Favorites")
                    }
                ShopMap()
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
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
