//
//  FavoriteMiniViewer.swift
//  ShopApp
//
//  Created by Hendrik Steen on 31.12.21.
//

import SwiftUI

struct FavoriteMiniViewer: View {
    let item: Item
    @StateObject var uvm: UserViewModel
    @Binding var showAddToCartView: Bool
    let deleteAction: (String) -> Void
    var body: some View {
        //UI für einen Favoriten
        VStack {
            HStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    NavigationLink {
                        //Über diesen NavigationLink wird die normale View eines Artikels angezeigt.
                        ItemDetail(uvm: uvm, item: item)
                            .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                                Button("Ok", role: .cancel) {}
                            }
                            
                    } label: {
                        AsyncImage(url: URL(string: item.imagePath)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                VStack(alignment: .leading,spacing: 25) {
                    Text(item.title)
                        .lineLimit(1)
                    //Im Eintrag wird der Rabatt angegeben und wenn dieser = 0 ist, dann gibt es keinen Rabatt ansonsten wird dieser hier abgezogen.
                    Text("\(String(format: "%.2f", item.discount != 0 ? (item.price - (item.price/100.0) * Double(item.discount)): item.price)) $")
                    Spacer()
                    
                }
                Spacer()
                VStack {
                    Button(action: {
                        //Dieser Knopf ruft die AddToCartView in der FavoritesView auf.
                        //uvm.placeholderItem = item, damit der User auswählen kann in welcher Größe der Artikel hinzugefügt wird
                        uvm.placeholderItem = item
                        withAnimation() {
                            showAddToCartView.toggle()
                        }
                    }, label: {
                        Image(systemName: "bag")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: (UIScreen.main.bounds.width / 2.5) / 2 , maxHeight: (UIScreen.main.bounds.width / 2.5) / 2)
                            .background(.black)
                            .cornerRadius(15)
                    })
                    Spacer()
                    Button(action: {
                        //Dieser Button löscht das Item von den Favoriten
                        deleteAction(item.id)
                    }, label: {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: (UIScreen.main.bounds.width / 2.5) / 2 , maxHeight: (UIScreen.main.bounds.width / 2.5) / 2)
                            .background(.gray.opacity(0.25))
                            .cornerRadius(15)
                    })

                }
            }
            .padding(1)
            Divider()
        }
        .padding(.horizontal,10)
    }
}

struct FavoriteMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMiniViewer(item: previewItem, uvm: UserViewModel(), showAddToCartView: .constant(true),deleteAction: {_ in})
    }
}
