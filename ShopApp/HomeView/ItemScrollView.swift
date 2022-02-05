//
//  ItemScrollView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 12.01.22.
//

import SwiftUI

struct ItemScrollView: View {
    let items: [Item]
    @StateObject var uvm: UserViewModel
    var nameOfCustomer: String
    @State private var searchText = ""
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Text("Hi,\n\(nameOfCustomer)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            LoginTextField(isSecure: false, value: $searchText, title: "search", systemImage: "")
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(items.filter { $0.title.contains(searchText) || searchText.isEmpty }) { item in
                    NavigationLink(destination: {
                        ItemDetail(item: item, addFavoriteAction: { 
                            if uvm.checkIfItemIsAlreadyFavorite(with: item.id) {
                                uvm.deleteFavoriteItem(with: item.id)
                            } else {
                                uvm.addItemToFavorites(with: item.id)
                            }
                        }, addToCartAction: { number in
                            uvm.addItemToCart(with: item.id, size: number, amount: 1)
                        }, checkFavoriteAction: {
                            return uvm.checkIfItemIsAlreadyFavorite(with: item.id)
                        })
                            .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                                Button("Ok", role: .cancel) {}
                            }
                        
                    }, label: {
                        MiniViewer(item: item)
                            
                    })
                        .buttonStyle(.plain)
                        .padding(.horizontal, 5)
                }
            }
        }
    }
}

struct ItemScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ItemScrollView(items: [], uvm: UserViewModel(), nameOfCustomer: "???")
    }
}
