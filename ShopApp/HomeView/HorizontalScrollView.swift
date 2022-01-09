//
//  HorizontalScrollView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct HorizontalScrollView: View {
    let items: [Item]
    let title: String
    @StateObject var uvm: UserViewModel
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
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
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView(items: [Item(_title: "jordan 1",
                                          _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                          _price: 129.99,
                                          _sizes: [41,42,43,44,45,46,47],
                                          _availableSizes: [41,42,46,47],
                                          _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                          _rating: 2.5,
                                          _id: "00003401",
                                          _discount: 0
                                         )], title: "Bestseller", uvm: UserViewModel())
    }
}
