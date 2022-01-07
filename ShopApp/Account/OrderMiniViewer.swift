//
//  OrderMiniViewer.swift
//  ShopApp
//
//  Created by Hendrik Steen on 07.01.22.
//

import SwiftUI

struct OrderMiniViewer: View {
    let order: Order
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(String(format: "%.2f", order.price))$")
                .fontWeight(.bold)
                .font(.largeTitle)
            Text("\(order.items.count) \(order.items.count > 1 ? "items" : "item")")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("ID: \(order.id)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
        }
    }
}

struct OrderMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        OrderMiniViewer(order: Order(price: 129.99, items: [CartItem(_item: Item(_title: "Jordan 1",
                                                                                 _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                                                 _price: 129.99,
                                                                                 _sizes: [41,42,43,44,45,46,47],
                                                                                 _availableSizes: [41,42,46,47],
                                                                                 _imagePath: "https://firebasestorage.googleapis.com/v0/b/shopapp-f01dd.appspot.com/o/Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1.png?alt=media&token=f9acbbee-9ff1-465f-b1e9-f639d05e8f74",
                                                                                 _rating: 2.5,
                                                                                 _id: "00003401",
                                                                                 _discount: 0
                                                                                ), _size: 45, _amount: 1, _id: "asdf")], deliverydate: Date.now, id: "gsgadsg"))
    }
}
