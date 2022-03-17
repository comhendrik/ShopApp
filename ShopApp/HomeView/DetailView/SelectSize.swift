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
            ForEach(0 ..< item.sizes.count) { size in
                SelectSizeButton(size: $actualSize, sizes: item.sizes, changingSizeIndex: size, amountOfSizes: item.amountOfSizes)
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
    let sizes: [Int]
    let changingSizeIndex: Int
    let amountOfSizes: [Int]
    var body: some View {
        Button(action: {
            if amountOfSizes[changingSizeIndex] > 0 {
                size = sizes[changingSizeIndex]
                
            }
        }, label: {
            Text("\(sizes[changingSizeIndex])")
                .font(.system(size: UIScreen.main.bounds.width / 20))
                .padding()
                .background(size == sizes[changingSizeIndex] ? .gray.opacity(0.35) : .clear)
                .foregroundColor(amountOfSizes[changingSizeIndex] > 0 ? .black : .gray)
                .cornerRadius(10, antialiased: false)
                
        })
            .disabled(amountOfSizes[changingSizeIndex] == 0)
    }
}
