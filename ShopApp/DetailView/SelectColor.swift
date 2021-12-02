//
//  SelectColor.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct SelectColor: View {
    @Binding var shoeIndex: Int
    let item: Item
    var body: some View {
        HStack {
            ForEach(0 ..< item.colors.count) { color in
                SelectColorButton(shoeIndex: $shoeIndex, changingIndex: color, changingColor: item.colors[color], colors: item.colors,availableColors: item.availableColors)
            }
        }
        .padding(.bottom, 1)
    }
}

struct SelectColor_Previews: PreviewProvider {
    static var previews: some View {
        SelectColor(shoeIndex: .constant(0), item: Item(_title: "off white jordanm",
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

struct SelectColorButton: View {
    @Binding var shoeIndex: Int
    let changingIndex: Int
    let changingColor: Color
    let colors: [Color]
    let availableColors: [Color]
    var body: some View {
        Button(action: {
            if availableColors.contains(changingColor) {
                shoeIndex = changingIndex
            } else {
                //TODO: Alert or something like that
                shoeIndex = changingIndex
                print("not available")
            }
            
        }, label: {
            Image(systemName: availableColors.contains(changingColor) ? colors[shoeIndex] == changingColor ? "circle.inset.filled" : "circle" : "circle.slash")
                .font(.title)
                .foregroundColor(changingColor == .white ? .gray : changingColor)
                
        })
    }
}
