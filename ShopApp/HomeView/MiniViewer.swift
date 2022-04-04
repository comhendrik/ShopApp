//
//  MiniViewer.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

struct MiniViewer: View {
    let item: Item
    var body: some View {
        //Diese View wird angezeigt in der HomeView, um die wichtigsten Information des Artikel darzustellen.
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.05))
                AsyncImage(url: URL(string: item.imagePath)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                } placeholder: {
                    ProgressView()
                }
                if calculateShoeSizeAmount(shoeSizes: item.sizes) == 0 {
                    //Mit dieser View wird signalisiert, dass der Artikel nicht verfügbar ist. Ein grau "Schicht" wird über die View gelegt.
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.5))
                }
            }
            .frame(width: UIScreen.main.bounds.width / 2.25, height: UIScreen.main.bounds.width / 2.25)
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .fontWeight(.bold)
                        .lineLimit(1)
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
            }
        }
    }
    
    private func calculateShoeSizeAmount(shoeSizes: [ShoeSize]) -> Int {
        var totalAmountOfSizes = 0
        for size in shoeSizes {
            totalAmountOfSizes += size.amount
        }
        return totalAmountOfSizes
    }
}

struct MiniViewer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MiniViewer(item: previewItem
            )
            MiniViewer(item: previewItem)
                .previewDevice("iPhone 8")
        }
    }
}
