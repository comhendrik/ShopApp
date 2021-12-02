//
//  SelectSize.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

//Implements the size selection

struct SelectSize: View {
    @Binding var actualSize: Int
    let item: Item
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0 ..< item.sizes.count) { size in
                    SelectSizeButton(size: $actualSize, changingSize: item.sizes[size], availableSizes: item.availableSizes)
                }
            }
        }
    }
}

struct SelectSize_Previews: PreviewProvider {
    static var previews: some View {
        SelectSize(actualSize: .constant(0),item: Item(_title: "off white jordanm",
                                                      _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                      _price: 129.99,
                                                      _sizes: [41,42,43,44,45,46,47],
                                                      _availableSizes: [41,42,46,47],
                                                      _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                                      _availableColors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                                      _imagePaths: ["Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1","Off-White-x-Jordan-1-UNC-Blue-2_w900"],
                                                      _rating: 2.5,
                                                       _id: "0000001",
                                                       _discount: 0)
        )
    }
}

struct SelectSizeButton: View {
    @Binding var size: Int
    let changingSize: Int
    let availableSizes: [Int]
    var body: some View {
        Button(action: {
            if availableSizes.contains(changingSize) {
                size = changingSize
                
            } else {
                //TODO: Add alert or something
                print("not available")
            }
        }, label: {
            Text("\(changingSize)")
                .font(.system(size: UIScreen.main.bounds.width / 20))
                .padding()
                .background(size == changingSize ? .gray.opacity(0.35) : .clear)
                .foregroundColor(availableSizes.contains(changingSize) ? .black : .gray)
                .cornerRadius(10, antialiased: false)
        })
    }
}
