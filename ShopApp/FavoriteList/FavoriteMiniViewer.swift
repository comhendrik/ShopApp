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
    let addToCartAction: () -> Void
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    NavigationLink {
                        ItemDetail(item: item, addFavoriteAction: {
                        }, addToCartAction: {_ in 
                            
                        })
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
                Spacer()
                VStack(alignment: .leading,spacing: 25) {
                    Text(item.title)
                        .fontWeight(.bold)
                    Text("\(String(format: "%.2f", item.discount != 0 ? (item.price - (item.price/100.0) * Double(item.discount)): item.price)) $")
                    
                }
            }
            HStack {
                Button(action: {
                    //TODO: delete action
                }, label: {
                    Text("Delete")
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width / 2.25)
                        .background(.gray.opacity(0.25))
                        .cornerRadius(15)
                })
                Spacer()
                Button(action: {
                    //TODO: add to cart action
                    addToCartAction()
                }, label: {
                    Text("Add to Cart")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width / 2.25)
                        .background(.black)
                        .cornerRadius(15)
                })
            }
            Divider()
        }
        .padding(.horizontal,10)
    }
}

struct FavoriteMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMiniViewer(item: Item(_title: "Jordan 1",
                                      _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                      _price: 129.99,
                                      _sizes: [41,42,43,44,45,46,47],
                                      _availableSizes: [41,42,46,47],
                                      _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                      _rating: 2.5,
                                      _id: "00003401",
                                      _discount: 0
                                     ), uvm: UserViewModel(), addToCartAction: {
            print("hello")
        })
    }
}
