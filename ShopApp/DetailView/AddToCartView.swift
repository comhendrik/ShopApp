//
//  AddToCartView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct AddToCartView: View {
    let item: Item
    @Binding var shoeSize: Int
    @Binding var colorIndex: Int
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .padding(.top, UIScreen.main.bounds.height / 3.5)
            VStack {
                Spacer()
                SelectColor(shoeIndex: $colorIndex, item: item)
                SelectSize(actualSize: $shoeSize, item: item)
                Text(item.description)
                    .font(.system(size: UIScreen.main.bounds.height < 700 ? 20 : 28))
                    .padding([.bottom, .horizontal])
                HStack {
                    if item.discount != 0 {
                        VStack {
                            Text("\(String(format: "%.2f", item.price))$")
                                .font(.system(size: 24))
                                .foregroundColor(Color.red)
                            Text("\(String(format: "%.2f", (item.price/100.0) * Double(item.discount)))$")
                                .font(.system(size: 20))
                                .strikethrough()
                                .foregroundColor(Color.gray.opacity(0.5))
                        }
                        
                    } else {
                        Text("\(String(format: "%.2f", item.price))$")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    VStack {
                        StarsView(rating: item.rating)
                            .padding()
                        Button(action: {
                            //TODO: Add Function to add to cart
                            print(shoeSize, item.colors[colorIndex])
                            print(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
                        }, label: {
                            Text(item.availableColors.contains(item.colors[colorIndex]) ? "Add To Cart" : "Not available")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .padding()
                                .background(item.colors[colorIndex])
                                .cornerRadius(15, antialiased: false)
                                
                        })
                            .disabled(!item.availableColors.contains(item.colors[colorIndex]))
                        
                    }
                }
                
            }
            .padding()
        }
    }
}

struct AddToCartView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCartView(item: Item(_title: "off white jordanm",
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
                                ), shoeSize: .constant(45), colorIndex: .constant(0)
        )
    }
}
