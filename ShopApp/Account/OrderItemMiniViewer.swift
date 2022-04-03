//
//  OrderItemMiniViewer.swift
//  ShopApp
//
//  Created by Hendrik Steen on 08.01.22.
//

import SwiftUI

struct OrderItemMiniViewer: View {
    let orderItem: OrderItem
    @StateObject var uvm: UserViewModel
    var body: some View {
        //Diese View zeigt Information zu den Artikeln einer Bestellung an
        VStack {
            HStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    NavigationLink(destination: {
                        //Über diesen NavigationLink wird die normale View eines Artikels angezeigt
                        ItemDetail(uvm: uvm, item: orderItem.item)
                            .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                                Button("Ok", role: .cancel) {}
                            }
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
                    Text("size: \(orderItem.size)")
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
        OrderItemMiniViewer(orderItem: OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "0000340146", _price: 129.99), uvm: UserViewModel())
    }
}
