//
//  OrderItemMiniViewer.swift
//  ShopApp
//
//  Created by Hendrik Steen on 08.01.22.
//

import SwiftUI

struct OrderItemMiniViewer: View {
    let orderItem: OrderItem
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    NavigationLink(destination: {
                        ItemDetail(item: orderItem.item,
                        addFavoriteAction: {
                            print("not properly handled")
                        }, addToCartAction: {_ in
                            print("not properly handled")
                        })
                    }, label: {
                        AsyncImage(url: URL(string: orderItem.item.imagePath)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                            
                        } placeholder: {
                            ProgressView()
                        }
                    })

                }
                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                VStack(alignment: .leading) {
                    Text(orderItem.item.title)
                    Text("amount: \(orderItem.amount)")
                        .foregroundColor(.gray)
                    Text(orderItem.item.id)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                Spacer()
                Text("\(String(format: "%.2f",orderItem.price))$")
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            Divider()
        }
    }
}

struct OrderItemMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemMiniViewer(orderItem: OrderItem(_item: Item(_title: "Jordan 1",
                                                           _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                           _price: 129.99,
                                                           _sizes: [41,42,43,44,45,46,47],
                                                           _availableSizes: [41,42,46,47],
                                                           _imagePath: "https://firebasestorage.googleapis.com/v0/b/shopapp-f01dd.appspot.com/o/Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1.png?alt=media&token=f9acbbee-9ff1-465f-b1e9-f639d05e8f74",
                                                           _rating: 2.5,
                                                           _id: "00003401",
                                                           _discount: 40
                                                            ), _size: 45, _amount: 1, _id: "0000340146", _price: 129.99))
    }
}
