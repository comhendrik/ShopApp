//
//  ContentView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var ivm = ItemViewModel()
    @StateObject var uvm = UserViewModel()
    var body: some View {
        TabView {
            HomeView(ivm: ivm)
                .tabItem{
                    Image(systemName: "house")
                    Text("home")
                        .foregroundColor(.black)
                }
            ShoppingCart(uvm: uvm, ivm: ivm)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
            FavoritesView(uvm: uvm, ivm: ivm)
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("Favorites")
                }
            MapView()
                .tabItem {
                    Image(systemName: "map.circle")
                    Text("map")
                }
            AccountView(uvm: uvm)
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
