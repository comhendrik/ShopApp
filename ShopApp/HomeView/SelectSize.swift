//
//  SelectSize.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI


struct SelectSize: View {
    @Binding var actualSize: Int
    let item: Item
    var body: some View {
        //Diese View ermöglicht es eine Größe für einen Schuh auszuwählen.
        LazyVGrid(columns: [GridItem(),GridItem(),GridItem(),GridItem()]) {
            ForEach(item.sizes) { size in
                SelectSizeButton(actualSize: $actualSize, shoeSize: size)
            }
        }
    }
}

struct SelectSize_Previews: PreviewProvider {
    static var previews: some View {
        SelectSize(actualSize: .constant(0),item: previewItem)
    }
}

struct SelectSizeButton: View {
    @Binding var actualSize: Int
    let shoeSize: ShoeSize
    var body: some View {
        Button(action: {
            //Dieser Button setzt die ausgewählte Größe auf die eigene, wenn die Menge es zulässt.
            if shoeSize.amount > 0 {
                actualSize = shoeSize.size
            }
        }, label: {
            Text("\(shoeSize.size)")
                .font(.system(size: UIScreen.main.bounds.width / 20))
                .padding()
                .background(actualSize == shoeSize.size ? .gray.opacity(0.35) : .clear)
                .foregroundColor(shoeSize.amount > 0 ? .black : .gray)
                .cornerRadius(10, antialiased: false)
                
        })
            .disabled(shoeSize.amount == 0)
    }
}
