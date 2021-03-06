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
    let addAction: (Item, Int) -> Bool
    @State private var shoeSize = 0
    let item: Item
    var body: some View {
        //Diese View ermöglicht es dem User einen Favoriten zum Warenkorb hinzuzufügen
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
                            //Im Eintrag wird der Rabatt angegeben und wenn dieser = 0 ist, dann gibt es keinen Rabatt ansonsten wird dieser hier abgezogen.
                            Text("\(String(format: "%.2f", item.discount != 0 ? (item.price - (item.price/100.0) * Double(item.discount)): item.price)) $")
                                .foregroundColor(item.discount != 0 ? .red : .none)
                            //Wenn ein Rabatt abgezogen werden soll, wird daneben ein durchgestrichener Text mit dem originalen Preis dargestellt.
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
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.title)
                        
                    })
                    
                 
                }
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(item.sizes) { size in
                            Button(action: {
                                if size.amount > 0 {
                                    shoeSize = size.size
                                }
                            }, label: {
                                Text("\(size.size)")
                                    .font(.system(size: UIScreen.main.bounds.width / 20))
                                    .padding()
                                    .background(size.size == shoeSize ? .gray.opacity(0.35) : .clear)
                                    //.foregroundColor(item.availableSizes.contains(item.sizes[size]) ? .black : .gray)
                                    .cornerRadius(10, antialiased: false)
                                    .foregroundColor(.black)
                            })
                            
                        }
                    }
                }
                
                Button(action: {
                    //Funktion zum hinzufügen des Warenkorbs wird ausgeführt wenn eine Größe ausgewählt wurde. Innerhalb der addAction wird dies geregelt. Das einzige was die View machen muss ist die AddToCartView wieder zu entfernen.
                    if addAction(item, shoeSize) {
                        withAnimation() {
                            showAddToCartView.toggle()
                        }
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
        
        .frame(height: UIScreen.main.bounds.height / 5)
        .padding()
    }
}

//struct AddToCartView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToCartView()
//    }
//}
