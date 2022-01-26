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
        VStack {
            HStack {
                    VStack(alignment: .leading) {
                        Text("\(String(format: "%.2f", order.price))$")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("\(order.items.count) \(order.items.count > 1 ? "items" : "item")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("ID: \(order.id)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("expected Delivery: \(order.deliverydate.formatted(date: .numeric, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            Divider()
        }
    }
}

struct OrderMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        OrderMiniViewer(order: Order(price: 129.99, items: [OrderItem(_item: Item(_title: "jordan 1",
                                                                                  _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                                                  _price: 129.99,
                                                                                  _sizes: [41,42,43,44,45,46,47],
                                                                                  _availableSizes: [41,42,46,47],
                                                                                  _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                                                                  _rating: 2.5,
                                                                                  _id: "00003401",
                                                                                                                                    _discount: 0, _inStock: 5
                                                                  ), _size: 45, _amount: 1, _id: "asdf", _price: 129.99)], deliverydate: Date.now, id: "gsgadsg"))
    }
}
