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
        NavigationView {
            VStack {
                NavigationLink("Orders", destination: {
                        ScrollView {
                            HStack {
                                Text("Order")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            ForEach(uvm.orders) { order in
                                OrderMiniViewer(order: order)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                })
                Text("\(uvm.mainUser.firstName),\(uvm.mainUser.lastName)")
                Text(uvm.mainUser.birthday)
                Text("\(uvm.mainUser.age)")
            }
            .navigationBarHidden(true)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(uvm: UserViewModel())
    }
}
