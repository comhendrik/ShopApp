//
//  AddToCartView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct AddToCartView: View {
    let item: Item
    var shoeSize: Int
    var colorIndex: Int
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: UIScreen.main.bounds.height / 4)
                .foregroundColor(.white)
            HStack {
                Text("\(String(format: "%.2f", item.price))$")
                    .font(.system(size: 25))
                    .padding()
                Spacer()
                VStack {
                    StarsView(rating: item.rating)
                        .padding()
                    Button(action: {
                        //TODO: Add Function to add to cart
                        print(shoeSize, item.colors[colorIndex])
                    }, label: {
                        Text("Add To Cart")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [.red,.blue]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15, antialiased: false)
                    })
                    
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
                                 _gradient: [.red,.blue],
                                 _sizes: [41,42,43,44,45,46,47],
                                 _availableSizes: [41,42,46,47],
                                 _colors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                 _availableColors: [Color.blue, Color.red, Color.white, Color.orange, Color.yellow],
                                 _imagePaths: ["Wethenew-Sneakers-France-Air-Jordan-1-High-85-Varsity-Red-BQ4422-600-1","Off-White-x-Jordan-1-UNC-Blue-2_w900"],
                                 _rating: 2.5), shoeSize: 45, colorIndex: 0
        )
    }
}
