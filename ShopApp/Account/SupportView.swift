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
            ForEach(order.items) { item in
                Button(action: {
                    spm.itemID = item.id
                }, label: {
                    Text(item.id)
                })
            }
            ForEach(SupportCases.allCases , id: \.self) { supportCase in
                Button(action: {
                    spm.supportCase = supportCase
                }, label: {
                    Text("\(supportCase.stringDescription)")
                })
            }
            
            TextField("supportMessage", text: $spm.supportMessage)
            
            Button(action: {
                print("\(spm.itemID), \(spm.supportCase.stringDescription), \(spm.supportMessage)")
                spm.createSupportRequest(idOfOrder: order.id)
            }, label: {
                Text("Create request")
            })

        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView(order: Order(price: 129.99, items: [OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "asdf", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "asdfasdf", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "ffff", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "sss", _price: 129.99)], orderDate: Date.now, id: "gsgadsg"))
    }
}
