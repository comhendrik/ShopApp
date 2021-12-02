//
//  ListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct ListView: View {
    @State private var categories = "shoes"
    let items: [Item]
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            HStack(spacing: 10) {
                Button(action: {
                    withAnimation() {
                        categories = "shoes"
                    }
                }, label: {
                    if categories != "shoes" {
                        Text("shoes")
                            .foregroundColor(.black)
                    } else {
                        Text("shoes")
                            .foregroundColor(.black)
                            .underline()
                    }
                })
                
                Button(action: {
                    withAnimation() {
                        categories = "pullover"
                    }
                }, label: {
                    if categories != "pullover" {
                        Text("pullover")
                            .foregroundColor(.black)
                    } else {
                        Text("pullover")
                            .foregroundColor(.black)
                            .underline()
                    }
                })
                
                Button(action: {
                    withAnimation() {
                        categories = "shirts"
                    }
                }, label: {
                    if categories != "shirts" {
                        Text("shirts")
                            .foregroundColor(.black)
                    } else {
                        Text("shirts")
                            .foregroundColor(.black)
                            .underline()
                    }
                })
                
                Button(action: {
                    withAnimation() {
                        categories = "trousers"
                    }
                }, label: {
                    if categories != "trousers" {
                        Text("trousers")
                            .foregroundColor(.black)
                    } else {
                        Text("trousers")
                            .foregroundColor(.black)
                            .underline()
                    }
                })
            }
            .padding()
            switch categories {
            case "pullover":
                HorizontalScrollView(items: items, title: "Bestseller")
                HorizontalScrollView(items: items, title: "Newest products")
                HorizontalScrollView(items: items, title: "recommende")
                
            case "shirts":
                HorizontalScrollView(items: items, title: "Bestseller")
                HorizontalScrollView(items: items, title: "Newest products")
                HorizontalScrollView(items: items, title: "recommende")
                
            case "trousers":
                HorizontalScrollView(items: items, title: "Bestseller")
                HorizontalScrollView(items: items, title: "Newest products")
                HorizontalScrollView(items: items, title: "recommende")
                
            default:
                HorizontalScrollView(items: items, title: "Bestseller")
                HorizontalScrollView(items: items, title: "Newest products")
                HorizontalScrollView(items: items, title: "recommende")
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(items: [Item(_title: "jordan 1",
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
                             )]
        )
    }
}


