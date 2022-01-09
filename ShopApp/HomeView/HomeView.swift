//
//  HomeView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var uvm: UserViewModel
    @StateObject var ivm: ItemViewModel
    let nameOfCustomer: String
    var body: some View {
        NavigationView {
            if ivm.showProgressView {
                Spacer()
                ProgressView()
                Button(action: {
                    ivm.showProgressView = false
                }, label: {
                    Text("Reload")
                })
                Spacer()
            } else {
                ListView(nameOfCustomer: nameOfCustomer, uvm: uvm, items: ivm.items)
                    .navigationBarHidden(true)
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(uvm: UserViewModel(),ivm: ItemViewModel(), nameOfCustomer: "customer")
    }
}
