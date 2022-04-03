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
    @State private var showEditView = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("\(uvm.mainUser.firstName) \(uvm.mainUser.lastName)")
                        .fontWeight(.bold)
                        .font(.title2)
                    Button(action: {
                        lvm.address = uvm.mainUser.adress
                        showEditView.toggle()
                    }, label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(-90))
                    })
                        .sheet(isPresented: $showEditView, content: { RegisterView(lvm: lvm, isRegisterView: false).padding() })
                        
                }
                Button(action: {
                    //Button zum Abmelden
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
                //Wenn man auf die AccountView geht, sieht man alle getätigten Bestellungen
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
                    ScrollView {
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
