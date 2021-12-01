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
                Image(item.imagePaths[0])
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: UIScreen.main.bounds.width / 2.25, height: UIScreen.main.bounds.width / 2.25)
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .fontWeight(.bold)
                    HStack {
                        Text("\(String(format: "%.2f", item.discount != 0 ? (item.price/100.0) * Double(item.discount): item.price)) $")
                            .foregroundColor(item.discount != 0 ? .red : .none)

                        if item.discount != 0 {
                            Text("\(String(format: "%.2f", item.price))")
                                .strikethrough()
                        }
                    }
                    .font(.subheadline)
                    Text("\(item.colors.count) Colors")
                        .foregroundColor(Color.gray.opacity(0.75))
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
                                  _gradient: [.red,.blue],
                                  _sizes: [41,42,43,44,45,46,47],
                                  _availableSizes: [41,42,46,47],
                                  _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                  _availableColors: [Color.blue, Color.red,Color.yellow],
                                  _imagePaths: ["Off-White-x-Jordan-1-UNC-Blue-2_w900", "Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1", "Wethenew-Sneakers-France-Air-Jordan-1-Mid-White-Shadow-554724-073-1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Turf-Orange-BQ6931-802-1_1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Dynamic-Yellow-1"],
                                  _rating: 2.5,
                                  _id: "0000001",
                                  _discount: 0
                                 )
            )
            MiniViewer(item: Item(_title: "jordan 1",
                                  _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                  _price: 129.99,
                                  _gradient: [.red,.blue],
                                  _sizes: [41,42,43,44,45,46,47],
                                  _availableSizes: [41,42,46,47],
                                  _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                  _availableColors: [Color.blue, Color.red,Color.yellow],
                                  _imagePaths: ["Off-White-x-Jordan-1-UNC-Blue-2_w900", "Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1", "Wethenew-Sneakers-France-Air-Jordan-1-Mid-White-Shadow-554724-073-1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Turf-Orange-BQ6931-802-1_1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Dynamic-Yellow-1"],
                                  _rating: 2.5,
                                  _id: "0000001",
                                  _discount: 0
                                 )
            )
                .previewDevice("iPhone 8")
        }
    }
}
