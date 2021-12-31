//
//  CartMiniViewer.swift
//  ShopApp
//
//  Created by Hendrik Steen on 31.12.21.
//

import SwiftUI

struct CartMiniViewer: View {
    var item: CartItem
    var body: some View {
        VStack {
            HStack {
                Text(item.item.title)
                    .fontWeight(.bold)
                Spacer()
                    
            }
            HStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    NavigationLink {
                        ItemDetail(item: item.item)
                    } label: {
                        Image(item.item.imagePath)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                VStack(alignment: .leading,spacing: 25) {
                    Text("Size: \(item.size)")
                    Text("\(String(format: "%.2f", item.item.discount != 0 ? (item.item.price - (item.item.price/100.0) * Double(item.item.discount)): item.item.price)) $")
                    Text("Amount: \(item.amount)")
                }
                Spacer()
                VStack {
                    Button(action: {
                        //TODO: Edit action
                    }, label: {
                        Text("Edit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 4)
                            .background(.black)
                            .cornerRadius(15)
                    })
                    Button(action: {
                    }, label: {
                        Text("Delete")
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 4)
                            .background(.gray.opacity(0.25))
                            .cornerRadius(15)
                    })
                }
            }
            Divider()
        }
        .padding(.horizontal,10)
    }
}

struct CartFavoriteMiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        CartMiniViewer(item: CartItem(_item: Item(_title: "Jordan 1",
                                                          _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                          _price: 129.99,
                                                          _sizes: [41,42,43,44,45,46,47],
                                                          _availableSizes: [41,42,46,47],
                                                          _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                                          _rating: 2.5,
                                                          _id: "00003401",
                                                          _discount: 40
                                                         ), _size: 45))
    }
}
