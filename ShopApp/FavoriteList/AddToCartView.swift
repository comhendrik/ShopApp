//
//  AddToCartView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.01.22.
//

import SwiftUI

struct AddToCartView: View {
    @StateObject var uvm: UserViewModel
    @Binding var showAddToCartView: Bool
    let addAction: (String, Int, Int) -> Void
    @State private var amount = 0
    @State private var shoeSize = 0
    let item: Item
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(15)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .fontWeight(.bold)
                        HStack {
                            Text("\(String(format: "%.2f", item.discount != 0 ? (item.price - (item.price/100.0) * Double(item.discount)): item.price)) $")
                                .foregroundColor(item.discount != 0 ? .red : .none)

                            if item.discount != 0 {
                                Text("\(String(format: "%.2f", item.price))")
                                    .strikethrough()
                            }
                        }
                        .font(.subheadline)
                    }
                    Spacer()
                    Button(action: {
                        withAnimation() {
                            showAddToCartView.toggle()
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.black)
                            .font(.title)
                        
                    })
                    
                 
                }
                
                HStack {
                    ZStack {
                        Color.gray.opacity(0.05)
                        AsyncImage(url: URL(string: item.imagePath)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .frame(width:
                            UIScreen.main.bounds.width / 2.5,
                           height: UIScreen.main.bounds.width / 2.5)
                    Spacer()
                    HStack {
                        Button(action: {
                            amount -= 1
                        }, label: {
                            Image(systemName: "arrow.backward.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        })
                        Text("\(amount)")
                            .font(.title)
                            .fontWeight(.bold)
                        Button(action: {
                            amount += 1
                        }, label: {
                            Image(systemName: "arrow.forward.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        })
                    }
                    .padding()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0 ..< item.sizes.count, id: \.self) { size in
                            Button(action: {
                                if item.availableSizes.contains(item.sizes[size]) {
                                    shoeSize = item.sizes[size]
                                } else {
                                    print("not available")
                                    //TODO: add alert for this case
                                }
                            }, label: {
                                Text("\(item.sizes[size])")
                                    .font(.system(size: UIScreen.main.bounds.width / 20))
                                    .padding()
                                    .background(item.sizes[size] == shoeSize ? .gray.opacity(0.35) : .clear)
                                    .foregroundColor(item.availableSizes.contains(item.sizes[size]) ? .black : .gray)
                                    .cornerRadius(10, antialiased: false)
                            })
                            
                        }
                    }
                }
                
                Button(action: {
                    //TODO: Add Function to add to cart
                    addAction(item.id,amount, shoeSize)
                    withAnimation() {
                        showAddToCartView.toggle()
                    }
                }, label: {
                    Text("Add to cart")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.black)
                        .cornerRadius(15, antialiased: false)
                        
                        
                })

            }
            .padding()
        }
        
        .frame(height: UIScreen.main.bounds.height / 3)
        .padding()
    }
}

//struct AddToCartView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToCartView()
//    }
//}
