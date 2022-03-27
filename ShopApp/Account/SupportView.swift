//
//  SupportView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.03.22.
//

import SwiftUI

struct SupportView: View {
    let order: Order
    @StateObject var spm = SupportViewModel()
    var body: some View {
        VStack {
            Text("Support:")
                .font(.largeTitle)
            Text("Select id of Item:")
                .fontWeight(.bold)
            ForEach(order.items) { orderItem in
                Button(action: {
                    spm.itemID = orderItem.item.id
                }, label: {
                    Text(orderItem.item.id)
                        .foregroundColor(spm.itemID == orderItem.item.id ? .black : .gray)
                })
            }
            Text("Select Support Case:")
                .fontWeight(.bold)
            ForEach(SupportCases.allCases , id: \.self) { supportCase in
                Button(action: {
                    spm.supportCase = supportCase
                }, label: {
                    Text("\(supportCase.stringDescription)")
                        .foregroundColor(spm.supportCase == supportCase ? .black : .gray)
                })
            }
            
            TextField("supportMessage", text: $spm.supportMessage)
            
            Button(action: {
                spm.createSupportRequest(idOfOrder: order.id)
            }, label: {
                Text("Create request")
            })
                .alert(spm.alertMsg, isPresented: $spm.alert) {
                    Button("OK", role: .cancel) { }
                }

        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView(order: Order(price: 129.99, items: [OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "asdf", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "asdfasdf", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "ffff", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "sss", _price: 129.99)], orderDate: Date.now, id: "gsgadsg"))
    }
}
