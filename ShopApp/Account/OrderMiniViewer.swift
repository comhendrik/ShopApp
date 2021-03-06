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
        //Diese View wird angezeigt, um die wichtigsten Daten einer Bestellung innerhalb der ScrollView in der AccountView darzustellen.
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
                        Text("Date of order: \(order.orderDate.formatted(date: .numeric, time: .omitted))")
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
        OrderMiniViewer(order: Order(price: 129.99, items: [OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "asdf", _price: 129.99)], orderDate: Date.now, id: "gsgadsg"))
    }
}
