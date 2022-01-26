//
//  ListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct ListView: View {
    @State private var categories = "Shoes"
    let nameOfCustomer: String
    @StateObject var uvm: UserViewModel
    let items: [Item]
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            HStack {
                Text("Hi,\n\(nameOfCustomer)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            CategorieNavigatorView(categories: $categories)
            switch categories {
            case "Pullover":
                ItemScrollView(items: items, uvm: uvm)
            case "Shirts":
                ItemScrollView(items: items, uvm: uvm)
            default:
                ItemScrollView(items: items, uvm: uvm)
            }
        }
        .padding()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(nameOfCustomer: "customer", uvm: UserViewModel(), items: [Item(_title: "jordan 1",
                              _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                              _price: 129.99,
                              _sizes: [41,42,43,44,45,46,47],
                              _availableSizes: [41,42,46,47],
                              _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                              _rating: 2.5,
                              _id: "00003401",
                                                                                _discount: 0, _inStock: 5
              )]
        )
    }
}


