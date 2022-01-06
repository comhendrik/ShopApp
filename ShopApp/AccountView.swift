//
//  AccountView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct AccountView: View {
    @StateObject var uvm: UserViewModel
    var body: some View {
        VStack {
            ScrollView {
                ForEach(uvm.orders) { order in
                    VStack {
                        Text(order.id)
                        Text("\(order.items.count)")
                    }
                }
            }
            .onAppear(perform: {
                uvm.getOrderInfo()
            })
            Text("\(uvm.mainUser.firstName),\(uvm.mainUser.lastName)")
            Text(uvm.mainUser.birthday)
            Text("\(uvm.mainUser.age)")
            Button(action: {
                print(uvm.orders)
            }, label: {
                Text("print")
            })
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(uvm: UserViewModel())
    }
}
