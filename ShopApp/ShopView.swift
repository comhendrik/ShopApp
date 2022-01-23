//
//  ShopView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 12.01.22.
//

import SwiftUI

struct ShopView: View {
    @StateObject var ivm = ItemViewModel()
    @StateObject var uvm = UserViewModel()
    @StateObject var lvm: LoginViewModel
    var body: some View {
        TabView {
            HomeView(uvm: uvm, ivm: ivm, nameOfCustomer: uvm.mainUser.firstName)
                .tabItem{
                    Image(systemName: "house")
                    Text("home")
                        .foregroundColor(.black)
                }
            ShoppingCart(uvm: uvm)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
            FavoritesView(uvm: uvm)
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("Favorites")
                }
            MapView()
                .tabItem {
                    Image(systemName: "map.circle")
                    Text("map")
                }
            AccountView(uvm: uvm, lvm: lvm)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("account")
                }
        }
        .onAppear {
            uvm.getUser()
            uvm.getCartItems()
            uvm.getFavoriteItems()
            Task {
                //Fetch Orders
                await uvm.getOrders()
            }
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(lvm: LoginViewModel())
    }
}
