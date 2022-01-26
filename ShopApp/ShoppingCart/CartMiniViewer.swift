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
        VStack {
            HStack {
                Text(cartItem.item.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    uvm.deleteCartItem(with: cartItem.id)
                }, label: {
                    Text("Delete")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                })
                
            }
            HStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    NavigationLink {
                        ItemDetail(item: cartItem.item,
                                   addFavoriteAction: {
                            uvm.addItemToFavorites(with: cartItem.item.id)
                        }, addToCartAction: {number in
                            return uvm.addItemToCart(with: cartItem.item.id, size: number, amount: 1)
                        }, checkFavoriteAction: {
                            return uvm.checkIfItemIsAlreadyFavorite(with: cartItem.item.id)
                        })
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
                Spacer()
                VStack(alignment: .leading,spacing: 25) {
                    Text("Size: \(cartItem.size)")
                    Text("\(String(format: "%.2f", cartItem.item.discount != 0 ? (cartItem.item.price - (cartItem.item.price/100.0) * Double(cartItem.item.discount)): cartItem.item.price)) $")
                    HStack {
                        Button(action: {
                            if cartItem.amount > 0 {
                                uvm.updateAmount(with: cartItem.id, amount: cartItem.amount-1)
                            }
                        }, label: {
                            Text("<")
                                .foregroundColor(.black)
                        })
                        Text("\(cartItem.amount)")
                        Button(action: {
                            uvm.updateAmount(with: cartItem.id, amount: cartItem.amount+1)
                        }, label: {
                            Text(">")
                                .foregroundColor(.black)
                        })
                    }
                }
                Spacer()
            }
            Divider()
        }
        .padding(.horizontal,10)
    }
}

struct CartFavoriteMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        CartMiniViewer(cartItem: CartItem(_item: Item(_title: "jordan 1",
                                                      _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                      _price: 129.99,
                                                      _sizes: [41,42,43,44,45,46,47],
                                                      _availableSizes: [41,42,46,47],
                                                      _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                                      _rating: 2.5,
                                                      _id: "00003401",
                                                                                                        _discount: 0, _inStock: 5
                                      ), _size: 45, _amount: 1, _id: "0000340146"),
                       uvm: UserViewModel())
                       }
}
