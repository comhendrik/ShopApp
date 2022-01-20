//
//  ItemDetail.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//
//Beispiel für einen USECASE:
//ItemDetail(item: item, addFavoriteAction: {
//    if uvm.checkIfItemIsAlreadyFavorite(with: item.id) {
//        uvm.deleteFavoriteItem(with: item.id)
//    } else {
//        uvm.addItemToFavorites(with: item.id)
//    }
//}, addToCartAction: { number in
//    uvm.addItemToCart(with: item.id, size: number, amount: 1)
//}, checkFavoriteAction: {
//    return uvm.checkIfItemIsAlreadyFavorite(with: item.id)
//})
//    .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
//        Button("Ok", role: .cancel) {}
//    }
import SwiftUI

struct ItemDetail: View {
    @State private var shoeSize = 0
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let item: Item
    let addFavoriteAction: () -> Void
    let addToCartAction: (Int) -> Bool
    let checkFavoriteAction: () -> Bool
    var body: some View {
        ScrollView {
            VStack {
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
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)

                HStack {
                    if item.discount != 0 {
                        VStack {
                            Text("\(String(format: "%.2f", (item.price - (item.price/100.0) * Double(item.discount))))$")
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
                AddAnimationButton {
                    return addToCartAction(shoeSize)
                }
                FavoriteAddAnimationButton(addAction: {
                    addFavoriteAction()
                }, checkFavoriteAction: {
                    return checkFavoriteAction()
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
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
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
                             ), addFavoriteAction: {
            print("hello")
        }, addToCartAction: {_ in 
            return true
        }, checkFavoriteAction: {
            return true
        }
        )
    }
}
