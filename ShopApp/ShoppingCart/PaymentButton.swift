//
//  ApplePayButton.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI
import UIKit

struct PaymentButton: View {
    let payBtnAction: () -> Void
    let price: String
    var body: some View {
        Button(action: {
            payBtnAction()
        }, label: {
            Text("$ \(price) | Purchase")
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(15)
                .frame(width: UIScreen.main.bounds.width - 50)
                .padding()
        })
            
            
    }
}
