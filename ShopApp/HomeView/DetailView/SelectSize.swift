//
//  SelectSize.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI

//Implements the size selection

struct SelectSize: View {
    @Binding var actualSize: Int
    let item: Item
    var body: some View {
        LazyVGrid(columns: [GridItem(),GridItem(),GridItem(),GridItem()]) {
            ForEach(item.sizes) { size in
                SelectSizeButton(size: $actualSize, shoeSize: size)
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
    @Binding var size: Int
    let shoeSize: ShoeSize
    var body: some View {
        Button(action: {
            if shoeSize.amount > 0 {
                size = shoeSize.size
            }
        }, label: {
            Text("\(shoeSize.size)")
                .font(.system(size: UIScreen.main.bounds.width / 20))
                .padding()
                .background(size == shoeSize.size ? .gray.opacity(0.35) : .clear)
                .foregroundColor(shoeSize.amount > 0 ? .black : .gray)
                .cornerRadius(10, antialiased: false)
                
        })
            .disabled(shoeSize.amount == 0)
    }
}
