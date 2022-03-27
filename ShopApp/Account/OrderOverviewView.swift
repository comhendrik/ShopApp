//
//  OrderOverviewView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 08.01.22.
//

import SwiftUI

struct OrderOverviewView: View {
    let order: Order
    @StateObject var uvm: UserViewModel
    @State private var showSupportView = false
    var body: some View {
        ScrollView {
            HStack {
                Text(order.id)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            ForEach(order.items) { orderItem in
                OrderItemMiniViewer(orderItem: orderItem, uvm: uvm)
            }
            HStack {
                Text("Sum:")
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(format: "%.2f",order.price))$")
                    .fontWeight(.bold)
            }
            .padding()
            
            Button(action: {
                showSupportView.toggle()
            }, label: {
                Text("Problems? We can help you!")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.black)
                    .cornerRadius(15, antialiased: false)
            })
                .sheet(isPresented: $showSupportView, content: { SupportView(order: order) })
        }
    }
}

//struct OrderOverviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderOverviewView()
//    }
//}
