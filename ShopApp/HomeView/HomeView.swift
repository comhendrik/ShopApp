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
        //Diese View begrüßt den Nutzer und enthält alle Artikel, sowie die Möglichkeiten, wie in Zeile 27 umgesetzt, nach den Artikelnamen zu suchen.
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    HStack {
                        Text("Hi,\n\(nameOfCustomer)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(items.filter { $0.title.contains(searchText) || searchText.isEmpty }) { item in
                            //Für jeden Artikel wird ein NavigationLink erstellt, um zur ItemDetail View zu kommen.
                            NavigationLink(destination: {
                                ItemDetail(uvm: uvm, item: item)
                                    .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                                        Button("Ok", role: .cancel) {}
                                    }
                                
                            }, label: {
                                MiniViewer(item: item)
                                    
                            })
                                .buttonStyle(.plain)
                        }
                    }
                    
                    
                    
                    
                }
                .navigationBarHidden(true)
                .padding()
                LoginTextField(isSecure: false, value: $searchText, title: "search", systemImage: "", viewWidth: nil)
                    .padding(.bottom)
            }
        }
        
    }
}

struct ItemScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(items: [], uvm: UserViewModel(), nameOfCustomer: "???")
    }
}
