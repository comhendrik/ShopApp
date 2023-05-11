//
//  ItemDetail.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//
import SwiftUI

struct ItemDetail: View {
    @State private var shoeSize = 0
    @StateObject var uvm: UserViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let item: Item
    var body: some View {
        //Diese View ist die Artikelseite und zeigt alle nötigen Information eines Artikels, sowie die Möglichkeit den Artikel dem Warenkorb und der Favoritenliste hinzuzufügen.
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
                    Text("\(item.id)")
                        .foregroundColor(.gray)
                        .fontWeight(.light)
                    Spacer()
                }
                .padding(.horizontal)

                HStack {
                    if item.discount != 0 {
                        //Im Eintrag wird der Rabatt angegeben und wenn dieser = 0 ist, dann gibt es keinen Rabatt ansonsten wird dieser hier abgezogen.
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
                    //TODO: Die Möglichkeit eine Bewertung abzuschicken.
                    StarsView(rating: item.rating)
                }
                .padding()
                
                Text(item.description)
                    .font(.system(size: UIScreen.main.bounds.height < 700 ? 15 : 20))
                    .padding()
                
                SelectSize(actualSize: $shoeSize, item: item)
                //Wenn die gesamte Menge > 0 ist, dann kann ein Artikel gekauft werden
                if calculateShoeSizeAmount(shoeSizes: item.sizes) > 0 {
                    AddAnimationButton {
                        return uvm.addItemToCart(itemToAdd: item, size: shoeSize, amount: 1)
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
                    //Es wird überprüft, ob das Item bereits ein Favorit ist, wenn ja muss es von der Favoritenliste gelöscht werden, ansonsten muss es hinzugefügt wird.
                    if uvm.checkIfItemIsAlreadyFavorite(with: item.id) {
                        uvm.deleteFavoriteItem(with: item.id)
                    } else {
                        uvm.addItemToFavorites(itemToAdd: item)
                    }
                }, checkFavoriteAction: {
                    //Diese Funktion aus Zeile 76 sorgt ebenfalls dafür, dass die Animation in die "richtige" Richtung ausgeführt wird. Also von Favorit nach kein Favorit oder umgekehrt.
                    return uvm.checkIfItemIsAlreadyFavorite(with: item.id)
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
        //In einer Variable wird gesamte Menge der Schuhgrößen gespeichert.
        var totalAmountOfSizes = 0
        for size in shoeSizes {
            totalAmountOfSizes += size.amount
        }
        return totalAmountOfSizes
    }
    
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(uvm: UserViewModel(), item: previewItem)
    }
}
