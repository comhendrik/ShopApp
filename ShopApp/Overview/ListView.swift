//
//  ListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct ListView: View {
    @State private var searchText = ""
    let items: [Item]
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        //TODO: Add profile page
                    }, label: {
                        Image(systemName: "person")
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .clipShape(Circle())
                    })
                    Spacer()
                    Button(action: {
                        //TODO: Add profile page
                    }, label: {
                        Image(systemName: "gearshape")
                            .padding()
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Circle())
                    })
                }
                .padding(.horizontal)
                HStack {
                    Text("Hi,\nCustomer!")
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(.horizontal)
                TextField("search", text: $searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25, antialiased: false)
                    .frame(width: UIScreen.main.bounds.width / 1.25)
                    .shadow(color: Color.gray, radius: 5, x: 0, y: 5)
                ScrollView(showsIndicators: false) {
                    HorizontalScrollView(items: items, title: "Bestseller")
                    HorizontalScrollView(items: items, title: "Newest products")
                    HorizontalScrollView(items: items, title: "recommende")
                }
                .ignoresSafeArea(.all)
            }
            .navigationBarHidden(true)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(items: [Item(_title: "jordan 1",
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
                             )]
        )
    }
}


