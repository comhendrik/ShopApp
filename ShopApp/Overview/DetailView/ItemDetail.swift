//
//  ItemDetail.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//

import SwiftUI

struct ItemDetail: View {
    @State private var shoeSize = 0
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let item: Item
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Color.gray.opacity(0.05)
                    Image(item.imagePath)
                        .resizable()
                        .scaledToFit()
                        .padding(.top, UIScreen.main.bounds.height / 10)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                HStack {
                    if item.discount != 0 {
                        VStack {
                            Text("\(String(format: "%.2f", (item.price/100.0) * Double(item.discount)))$")
                                .foregroundColor(Color.red)
                                
                            Text("\(String(format: "%.2f", item.price))$")
                                .strikethrough()
                                .foregroundColor(Color.gray.opacity(0.5))
                                

                        }
                        
                    } else {
                        Text("\(String(format: "%.2f", item.price))$")
                    }
                    Spacer()
                    
                    StarsView(rating: item.rating)
                }
                .padding()

                Text(item.description)
                    .font(.system(size: UIScreen.main.bounds.height < 700 ? 15 : 20))
                    .padding()
                
                SelectSize(actualSize: $shoeSize, item: item)
                Button(action: {
                    //TODO: Add Function to add to cart
                    print(shoeSize)
                }, label: {
                    Text("Add to cart")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.black)
                        .cornerRadius(15, antialiased: false)
                        
                        
                })
                Button(action: {
                    //TODO: Add Function to add to favorites
                }, label: {
                    Text("Add to favorites")
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.gray.opacity(0.25))
                        .cornerRadius(15, antialiased: false)
                        
                        
                })

            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
        })
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(item: Item(_title: "jordan 1",
                              _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                              _price: 129.99,
                              _sizes: [41,42,43,44,45,46,47],
                              _availableSizes: [41,42,46,47],
                              _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                              _rating: 2.5,
                              _id: "00003401",
                              _discount: 0
              )
        )
    }
}
