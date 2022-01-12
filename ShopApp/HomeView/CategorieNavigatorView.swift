//
//  CategorieNavigatorView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct CategorieNavigatorView: View {
    @Binding var categories: String
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            CategorieButtonView(categories: $categories, value: "Shoes")
            Spacer()
            CategorieButtonView(categories: $categories, value: "Pullover")
            Spacer()
            CategorieButtonView(categories: $categories, value: "Shirts")
            Spacer()
        }
        .padding([.top,.bottom])
    }
}

struct CategorieNavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        CategorieNavigatorView(categories: .constant("shoes"))
    }
}


struct CategorieButtonView: View {
    @Binding var categories: String
    var value: String
    var body: some View {
        Button(action: {
            withAnimation() {
                categories = value
            }
        }, label: {
            Text(value)
                .foregroundColor(categories != value ? .gray : .black)
                .fontWeight(categories == value ? .bold : nil)
        })
    }
}
