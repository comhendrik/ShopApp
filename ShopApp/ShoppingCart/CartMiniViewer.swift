//
//  CartMiniViewer.swift
//  ShopApp
//
//  Created by Hendrik Steen on 31.12.21.
//

import SwiftUI

struct CartMiniViewer: View {
    var cartItem: CartItem
    @StateObject var uvm: UserViewModel
    var body: some View {
        //In dieser View werden die Daten eines einzelnen Artikels des Warenkorbs dargestellt
        VStack {
            HStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    NavigationLink {
                        //Über diesen NavigationLink wird die normale View eines Artikels angezeig
                        ItemDetail(uvm: uvm, item: cartItem.item)
                            .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                                Button("Ok", role: .cancel) {}
                            }
                    } label: {
                        AsyncImage(url: URL(string: cartItem.item.imagePath)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                VStack(alignment: .leading) {
                    HStack {
                        Text(cartItem.item.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            //Button zum Löschen aus dem Warenkorb
                            
                            uvm.deleteCartItem(with: cartItem.id)
                        }, label: {
                            Text("Delete")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        })
                    }
                    Text("Size: \(cartItem.size)")
                    Text("\(String(format: "%.2f", cartItem.item.discount != 0 ? (cartItem.item.price - (cartItem.item.price/100.0) * Double(cartItem.item.discount)): cartItem.item.price)) $")
                    HStack {
                        //Die beiden Button erhöhen bzw. verringern die Menge, die bestellt werden soll.
                        Button(action: {
                            if cartItem.amount > 0 {
                                uvm.updateAmount(with: cartItem.id, amount: cartItem.amount-1)
                            }
                        }, label: {
                            Text("<")
                        })
                        Text("\(cartItem.amount)")
                        Button(action: {
                            uvm.updateAmount(with: cartItem.id, amount: cartItem.amount+1)
                        }, label: {
                            Text(">")
                        })
                    }
                    Spacer()
                }
                .foregroundColor(.gray)
            }
            .padding(.bottom, 5)
            Divider()
        }
        .padding()
    }
}

struct CartFavoriteMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        CartMiniViewer(cartItem: CartItem(_item: previewItem, _size: 45, _amount: 1, _id: "0000340146"),
                       uvm: UserViewModel())
                       }
}
