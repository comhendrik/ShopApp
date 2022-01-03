//
//  EditView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.01.22.
//

import SwiftUI

struct EditView: View {
    @Binding var item: CartItem
    let saveAction: (Int,String) -> Void
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
                        AsyncImage(url: URL(string: item.item.imagePath)) { image in
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
                    VStack {
                        HStack {
                            Button(action: {
                                item.amount -= 1
                            }, label: {
                                Image(systemName: "arrow.backward.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                            })
                            Text("\(item.amount)")
                                .font(.title)
                                .fontWeight(.bold)
                            Button(action: {
                                item.amount += 1
                            }, label: {
                                Image(systemName: "arrow.forward.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                            })
                        }
                        .padding()
                        Button(action: {
                            saveAction(item.amount,item.id)
                        }, label: {
                            Text("Save")
                                .foregroundColor(.white)
                                .padding()
                                .background(.black)
                                .cornerRadius(15)
                                .frame(width: UIScreen.main.bounds.width / 3)
                        })
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
        EditView(item: .constant(CartItem(_item: Item(_title: "Jordan 1",
                                                      _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                      _price: 129.99,
                                                      _sizes: [41,42,43,44,45,46,47],
                                                      _availableSizes: [41,42,46,47],
                                                      _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                                      _rating: 2.5,
                                                      _id: "00003401",
                                                      _discount: 40
                                                     ), _size: 42, _amount: 1)), saveAction: {amount, id in},
                 showEditView: .constant(true))
    }
}
