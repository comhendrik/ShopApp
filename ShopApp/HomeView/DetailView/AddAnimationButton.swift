//
//  AddAnimation.swift
//  ShopApp
//
//  Created by Hendrik Steen on 16.01.22.
//

import SwiftUI

struct AddAnimationButton: View {
    @State private var doAnimation = false
    @State private var disableButton = false
    let addAction: () -> Void
    var body: some View {
        ZStack {

            Button(action: {
                addAction()
                fullAnimation()
            }, label: {
                Text("Add to cart")
                    .foregroundColor(disableButton ? .black : .white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.black)
                    .cornerRadius(15, antialiased: false)
            })
            Image(systemName: "cart")
                .foregroundColor(.white)
                .offset(x: doAnimation ?
                        UIScreen.main.bounds.width / 2:
                            -UIScreen.main.bounds.width / 2 + 125)
                .scaleEffect(2.0)
            Image(systemName: "bag")
                .foregroundColor(.white)
                .opacity(doAnimation ? 1.0 : 0)
                .scaleEffect(2.0)
        }
        .disabled(disableButton)

    }
    private func fullAnimation() {
        disableButton = true
        withAnimation(.easeOut(duration: 2.0)) {
            doAnimation.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            doAnimation.toggle()
            disableButton = false
        }
    }
}

struct AddAnimationButton_Previews: PreviewProvider {
    static var previews: some View {
        AddAnimationButton(addAction: {
            print("Hello")
        })
            .previewDevice("iPhone 13")
    }
}
