//
//  AccountView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI
import FirebaseAuth
struct AccountView: View {
    @StateObject var uvm: UserViewModel
    @StateObject var lvm: LoginViewModel
    var body: some View {
        NavigationView {
            VStack {
                
                Text("\(uvm.mainUser.firstName) \(uvm.mainUser.lastName)")
                    .fontWeight(.bold)
                    .font(.title2)
                Button(action: {
                    lvm.logOut()
                }, label: {
                    Text("Logout")
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                })
                HStack {
                    Text("Orders:")
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                ScrollView {
                    if uvm.orders.count <= 0 {
                        VStack {
                            Spacer()
                            Text("No orders")
                                .font(.title3)
                            Image(systemName: "bag")
                                .font(.largeTitle)
                            Spacer()
                        }
                    } else {
                        ForEach(uvm.orders) { order in
                            NavigationLink(destination: {
                                OrderOverviewView(order: order, uvm: uvm)
                            }, label: {
                                OrderMiniViewer(order: order)
                            })
                        }
                    }
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(uvm: UserViewModel(), lvm: LoginViewModel())
    }
}
