//
//  EditView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.01.22.
//

import SwiftUI

struct EditView: View {
    let item: CartItem
    let changeSize: (Int) -> Void
    let changeAmount: (Int) -> Void
    @Binding var showEditView: Bool
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(15)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.item.title)
                            .fontWeight(.bold)
                        HStack {
                            Text("\(String(format: "%.2f", item.item.discount != 0 ? (item.item.price - (item.item.price/100.0) * Double(item.item.discount)): item.item.price)) $")
                                .foregroundColor(item.item.discount != 0 ? .red : .none)

                            if item.item.discount != 0 {
                                Text("\(String(format: "%.2f", item.item.price))")
                                    .strikethrough()
                            }
                        }
                        .font(.subheadline)
                    }
                    Spacer()
                    Button(action: {
                        withAnimation() {
                            showEditView.toggle()
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
                        Image(item.item.imagePath)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width:
                            UIScreen.main.bounds.width / 2.5,
                           height: UIScreen.main.bounds.width / 2.5)
                    Spacer()
                    HStack {
                        Button(action: {
                            changeAmount(-1)
                        }, label: {
                            Image(systemName: "arrow.backward.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        })
                        Text("\(item.amount)")
                            .font(.title)
                            .fontWeight(.bold)
                        Button(action: {
                            changeAmount(1)
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
                        ForEach(0 ..< item.item.sizes.count) { size in
                            Button(action: {
                                if item.item.availableSizes.contains(item.item.sizes[size]) {
                                    changeSize(item.item.sizes[size])
                                } else {
                                    print("not available")
                                    //TODO: add alert for this case
                                }
                            }, label: {
                                Text("\(item.item.sizes[size])")
                                    .font(.system(size: UIScreen.main.bounds.width / 20))
                                    .padding()
                                    .background(item.item.sizes[size] == item.size ? .gray.opacity(0.35) : .clear)
                                    .foregroundColor(item.item.availableSizes.contains(item.item.sizes[size]) ? .black : .gray)
                                    .cornerRadius(10, antialiased: false)
                            })
                            
                        }
                    }
                }

            }
            .padding()
        }
        
        .frame(height: UIScreen.main.bounds.height / 3)
        .padding()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(item: CartItem(_item: Item(_title: "Jordan 1",
                                            _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                            _price: 129.99,
                                            _sizes: [41,42,43,44,45,46,47],
                                            _availableSizes: [41,42,46,47],
                                            _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                            _rating: 2.5,
                                            _id: "00003401",
                                            _discount: 40
                                           ), _size: 42),
                 changeSize: {_ in},
                 changeAmount: {_ in },
                 showEditView: .constant(true))
    }
}
