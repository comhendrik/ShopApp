//
//  ListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct ListView: View {
    @State private var categories = "Shoes"
    let items: [Item]
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            HStack {
                Text("Hi,\nCustomer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            CategorieNavigatorView(categories: $categories)
            switch categories {
            case "Pullover":
                HorizontalScrollView(items: items, title: "Bestseller")
                HorizontalScrollView(items: items, title: "Newest products")
                HorizontalScrollView(items: items, title: "Recommended")
                
            case "Shirts":
                HorizontalScrollView(items: items, title: "Bestseller")
                HorizontalScrollView(items: items, title: "Newest products")
                HorizontalScrollView(items: items, title: "Recommended")
                
            case "Trousers":
                HorizontalScrollView(items: items, title: "Bestseller")
                HorizontalScrollView(items: items, title: "Newest products")
                HorizontalScrollView(items: items, title: "Recommended")
                
            default:
                HorizontalScrollView(items: items, title: "Bestseller")
                HorizontalScrollView(items: items, title: "Newest products")
                HorizontalScrollView(items: items, title: "Recommended")
            }
        }
        .padding()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(items: [Item(_title: "jordan 1",
                              _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                              _price: 129.99,
                              _sizes: [41,42,43,44,45,46,47],
                              _availableSizes: [41,42,46,47],
                              _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                              _rating: 2.5,
                              _id: "00003401",
                              _discount: 0
              )]
        )
    }
}


