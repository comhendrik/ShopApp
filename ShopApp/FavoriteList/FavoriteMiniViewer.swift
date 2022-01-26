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
        VStack {
            HStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    NavigationLink {
                        ItemDetail(item: item, addFavoriteAction: {
                            if uvm.checkIfItemIsAlreadyFavorite(with: item.id) {
                                uvm.deleteFavoriteItem(with: item.id)
                            } else {
                                uvm.addItemToFavorites(with: item.id)
                            }
                        }, addToCartAction: { number in
                            uvm.addItemToCart(with: item.id, size: number, amount: 1)
                        }, checkFavoriteAction: {
                            return uvm.checkIfItemIsAlreadyFavorite(with: item.id)
                        })
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
                        .fontWeight(.bold)
                    Text("\(String(format: "%.2f", item.discount != 0 ? (item.price - (item.price/100.0) * Double(item.discount)): item.price)) $")
                    Spacer()
                    
                }
                Spacer()
                VStack {
                    Button(action: {
                        uvm.placeholderItem = item
                        withAnimation() {
                            showAddToCartView.toggle()
                        }
                    }, label: {
                        Text("Buy")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 4.5)
                            .background(.black)
                            .cornerRadius(15)
                    })
                    Button(action: {
                        deleteAction(item.id)
                        for i in 0 ..< uvm.favoriteItems.count {
                            if uvm.favoriteItems[i].id == item.id {
                                uvm.favoriteItems.remove(at: i)
                                break
                            }
                        }
                    }, label: {
                        Text("Delete")
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 4.5)
                            .background(.gray.opacity(0.25))
                            .cornerRadius(15)
                    })

                }
                .padding(.horizontal)
            }
            Divider()
        }
        .padding(.horizontal,10)
    }
}

struct FavoriteMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMiniViewer(item: Item(_title: "jordan 1",
                                      _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                      _price: 129.99,
                                      _sizes: [41,42,43,44,45,46,47],
                                      _availableSizes: [41,42,46,47],
                                      _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                      _rating: 2.5,
                                      _id: "00003401",
                                                                                        _discount: 0, _inStock: 5
                      ), uvm: UserViewModel(), showAddToCartView: .constant(true),deleteAction: {_ in})
    }
}
