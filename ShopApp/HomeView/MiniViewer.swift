//
//  MiniViewer.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct MiniViewer: View {
    let item: Item
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.05))
                AsyncImage(url: URL(string: item.imagePath)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(width: UIScreen.main.bounds.width / 2.25, height: UIScreen.main.bounds.width / 2.25)
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .fontWeight(.bold)
                    HStack {
                        Text("\(String(format: "%.2f", item.discount != 0 ? (item.price - (item.price/100.0) * Double(item.discount)): item.price)) $")
                            .foregroundColor(item.discount != 0 ? .red : .none)

                        if item.discount != 0 {
                            Text("\(String(format: "%.2f", item.price))")
                                .strikethrough()
                        }
                    }
                    .font(.subheadline)
                        
                    
                }
                Spacer()
            }
        }
    }
}

struct MiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MiniViewer(item: Item(_title: "jordan 1",
                                  _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                  _price: 129.99,
                                  _sizes: [41,42,43,44,45,46,47],
                                  _availableSizes: [41,42,46,47],
                                  _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                  _rating: 2.5,
                                  _id: "00003401",
                                  _discount: 0
                  )
            )
            MiniViewer(item: Item(_title: "jordan 1",
                                  _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                  _price: 129.99,
                                  _sizes: [41,42,43,44,45,46,47],
                                  _availableSizes: [41,42,46,47],
                                  _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                  _rating: 2.5,
                                  _id: "00003401",
                                  _discount: 0
                  )
            )
                .previewDevice("iPhone 8")
        }
    }
}
