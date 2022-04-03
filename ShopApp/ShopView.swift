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
    @State private var showAppProgressView = false
    var body: some View {
        //Diese View enthält eine TabView mit allen Sektion in der App.
        //Diew Views finden sich unter dem gleichnamigen Ordner wieder.
        TabView {
            //Während die Daten laden wird eine ProgressView angezeigt.
            if showAppProgressView {
                ProgressView()
            } else {
                HomeView(items: ivm.allItems, uvm: uvm, nameOfCustomer: uvm.mainUser.firstName)
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
                AccountView(uvm: uvm, lvm: lvm)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("account")
                    }
            }
        }
        .onAppear {
            showAppProgressView = true
            //Wird diese View aufgerufen, werden diese Funktion aufgerufen, damit alle wichtigen Daten bereitgestellt werden.
            uvm.getUser()
            
            Task {
                //Fetch Orders, CartItems, FavoriteItems
                await uvm.getOrders()
                await uvm.getCartItems()
                await uvm.getFavoriteItems()
                await ivm.getAllItems()
                showAppProgressView = false
            }
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(lvm: LoginViewModel())
    }
}
