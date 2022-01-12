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
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(items) { item in
                    NavigationLink(destination: {
                        ItemDetail(item: item, addFavoriteAction: {
                            print("added?")
                            uvm.addItemToFavorites(with: item.id)
                        }, addToCartAction: { number in
                            uvm.addItemToCart(with: item.id, size: number, amount: 1)
                        })
                        
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
        ItemScrollView(items: [], uvm: UserViewModel())
    }
}
