//
//  ApplePayButton.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI
import UIKit
import PassKit

struct PaymentButton: View {
    let addAction: () -> Void
    var body: some View {
        Button(action: {
            print("order acceptet")
            //TODO: Handle this properly. With custom alert, etc.
            addAction()
            /* Your custom payment code here */
        }, label: { EmptyView() } )
            .buttonStyle(PaymentButtonStyle())
    }
}
struct PaymentButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return PaymentButtonHelper()
    }
}
struct PaymentButtonHelper: View {
    var body: some View {
        PaymentButtonRepresentable()
            .frame(minWidth: 100, maxWidth: 400)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
    }
}
extension PaymentButtonHelper {
    struct PaymentButtonRepresentable: UIViewRepresentable {
     
        var button: PKPaymentButton {
            let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black) /*customize here*/
            button.cornerRadius = 15 /* also customize here */
            return button
        }
     
        func makeUIView(context: Context) -> PKPaymentButton {
            return button
        }
        func updateUIView(_ uiView: PKPaymentButton, context: Context) { }
    }
}
