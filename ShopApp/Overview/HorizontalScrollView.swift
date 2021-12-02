//
//  HorizontalScrollView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct HorizontalScrollView: View {
    let items: [Item]
    let title: String
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items) { item in
                        NavigationLink(destination: {
                            ItemDetail(item: item)
                            
                        }, label: {
                            MiniViewer(item: item)
                                
                        })
                            .buttonStyle(.plain)
                            .padding(.horizontal, 5)
                    }
                }
            }
        }
    }
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView(items: [Item(_title: "jordan 1",
                                          _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                          _price: 129.99,
                                          _sizes: [41,42,43,44,45,46,47],
                                          _availableSizes: [41,42,46,47],
                                          _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                          _availableColors: [Color.blue, Color.red,Color.yellow],
                                          _imagePaths: ["Off-White-x-Jordan-1-UNC-Blue-2_w900", "Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1", "Wethenew-Sneakers-France-Air-Jordan-1-Mid-White-Shadow-554724-073-1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Turf-Orange-BQ6931-802-1_1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Dynamic-Yellow-1"],
                                          _rating: 2.5,
                                          _id: "00003401",
                                          _discount: 0
                          ),
                                       Item(_title: "jordan 1",
                                                       _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                       _price: 129.99,
                                                       _sizes: [41,42,43,44,45,46,47],
                                                       _availableSizes: [41,42,46,47],
                                                       _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                                       _availableColors: [Color.blue, Color.red,Color.yellow],
                                                       _imagePaths: ["Off-White-x-Jordan-1-UNC-Blue-2_w900", "Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1", "Wethenew-Sneakers-France-Air-Jordan-1-Mid-White-Shadow-554724-073-1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Turf-Orange-BQ6931-802-1_1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Dynamic-Yellow-1"],
                                                       _rating: 2.5,
                                                       _id: "00055001",
                                            _discount: 0
                                       ), Item(_title: "jordan 1",
                                               _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                               _price: 129.99,
                                               _sizes: [41,42,43,44,45,46,47],
                                               _availableSizes: [41,42,46,47],
                                               _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                               _availableColors: [Color.blue, Color.red,Color.yellow],
                                               _imagePaths: ["Off-White-x-Jordan-1-UNC-Blue-2_w900", "Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1", "Wethenew-Sneakers-France-Air-Jordan-1-Mid-White-Shadow-554724-073-1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Turf-Orange-BQ6931-802-1_1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Dynamic-Yellow-1"],
                                               _rating: 2.5,
                                               _id: "00340001",
                                               _discount: 0
                               ), Item(_title: "jordan 1",
                                       _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                       _price: 129.99,
                                       _sizes: [41,42,43,44,45,46,47],
                                       _availableSizes: [41,42,46,47],
                                       _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                       _availableColors: [Color.blue, Color.red,Color.yellow],
                                       _imagePaths: ["Off-White-x-Jordan-1-UNC-Blue-2_w900", "Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1", "Wethenew-Sneakers-France-Air-Jordan-1-Mid-White-Shadow-554724-073-1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Turf-Orange-BQ6931-802-1_1","Wethenew-Sneakers-France-Air-Jordan-1-Mid-Dynamic-Yellow-1"],
                                       _rating: 2.5,
                                       _id: "0000001",
                                       _discount: 0
                       )], title: "Bestseller")
    }
}
