//
//  ItemScrollView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 12.01.22.
//

import SwiftUI

struct HomeView: View {
    let items: [Item]
    @StateObject var uvm: UserViewModel
    var nameOfCustomer: String
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                HStack {
                    Text("Hi,\n\(nameOfCustomer)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                LoginTextField(isSecure: false, value: $searchText, title: "search", systemImage: "")
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(items.filter { $0.title.contains(searchText) || searchText.isEmpty }) { item in
                        NavigationLink(destination: {
                            ItemDetail(uvm: uvm, item: item)
                                .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                                    Button("Ok", role: .cancel) {}
                                }
                            
                        }, label: {
                            MiniViewer(item: item)
                                
                        })
                            .buttonStyle(.plain)
                            .padding(.horizontal, 5)
                    }
                }
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
}

struct ItemScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(items: [], uvm: UserViewModel(), nameOfCustomer: "???")
    }
}
