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
//        uvm.addItemToFavorites(itemToAdd: item)
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
                if calculateShoeSizeAmount(shoeSizes: item.sizes) > 0 {
                    AddAnimationButton {
                        return addToCartAction(shoeSize)
                    }
                } else {
                    //Falls ein Artikel ausverkauft ist wird diese View angezeigt und der Kunde kann den Artikel nicht bestellen
                    Text("Not available in this size")
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.gray)
                        .cornerRadius(15, antialiased: false)
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
    
    private func calculateShoeSizeAmount(shoeSizes: [ShoeSize]) -> Int {
        var totalAmountOfSizes = 0
        for size in shoeSizes {
            totalAmountOfSizes += size.amount
        }
        return totalAmountOfSizes
    }
    
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(item: previewItem, addFavoriteAction: {
        }, addToCartAction: {_ in 
            return true
        }, checkFavoriteAction: {
            return true
        }
        )
    }
}
