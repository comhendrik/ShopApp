//
//  HomeView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var ivm: ItemViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Hi,\nCustomer")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            Divider()
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
                ListView(items: ivm.items)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(ivm: ItemViewModel())
    }
}
