//
//  ItemDetail.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//

import SwiftUI

struct ItemDetail: View {
    @State private var colorIndex = 0
    @State private var shoeSize = 0
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let item: Item
    var body: some View {
        ZStack {
            item.colors[colorIndex]
            VStack {
                Image(item.imagePaths[colorIndex])
                    .resizable()
                    .scaledToFit()
                    .padding(.top, UIScreen.main.bounds.height / 10)
                Spacer()
            }
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text(item.title)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                }
                .padding(.top, UIScreen.main.bounds.height / 40)
                .padding()
                Spacer()


                AddToCartView(item: item, shoeSize: $shoeSize, colorIndex: $colorIndex)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
        })
        .ignoresSafeArea(.all)
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(item: Item(_title: "off white jordanm",
                              _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                              _price: 129.99,
                              _sizes: [41,42,43,44,45,46,47],
                              _availableSizes: [41,42,46,47],
                              _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                              _availableColors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                              _imagePaths: ["Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1","Off-White-x-Jordan-1-UNC-Blue-2_w900"],
                              _rating: 2.5,
                              _id: "0000001",
                                                         _discount: 0
                                                        )
        )
    }
}
