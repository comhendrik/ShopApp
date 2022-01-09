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
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(uvm.mainUser.firstName),\(uvm.mainUser.lastName)")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                        Text(uvm.mainUser.birthday)
                        Text("\(uvm.mainUser.age)")
                    }
                    .padding()
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("\(uvm.mainUser.adress.street) \(uvm.mainUser.adress.number)")
                        Text("\(uvm.mainUser.adress.zipCode) \(uvm.mainUser.adress.street)")
                        Text(uvm.mainUser.adress.land)
                    }
                    .padding()
                    
                }
                .padding()
                
                Spacer()
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
                                NavigationLink(destination: {
                                    OrderOverviewView(order: order)
                                }, label: {
                                    OrderMiniViewer(order: order)
                                })
                            }
                        }
                })
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
