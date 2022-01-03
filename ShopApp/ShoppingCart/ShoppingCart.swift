//
//  ShoppingCart.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCart: View {
    @StateObject var uvm: UserViewModel
    @StateObject var ivm: ItemViewModel
    @State private var showEditView = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ShoppingCartListView(uvm: uvm, ivm: ivm, showEditView: $showEditView)
                    HStack {
                        Text("Sum:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(format: "%.2f", calculateCost(items: uvm.cartItems)))$")
                        
                    }
                    .padding(.horizontal)
                    PaymentButton()
                        .scaledToFit()
                        .padding()
                }
                .blur(radius: showEditView ? 5 : 0)
                VStack {
                    Spacer()
                    EditView(item: $uvm.placeholderCartItem,
                             saveAction: {amount, id in
                        ivm.updateAmount(with: id, amount: amount)
                        withAnimation() {
                            showEditView.toggle()
                        }
                    },
                             showEditView: $showEditView)
                        .offset(y: showEditView ? 0 : 400)
                    
                }
            }
            .navigationBarHidden(true)
        }
        
    }
    
    private func calculateCost(items: [CartItem]) -> Double {
        var cost = 0.0
        for item in items {
            if item.item.discount == 0 {
                cost += item.item.price * Double(item.amount)
            } else {
                cost += (item.item.price - (item.item.price/100.0) * Double(item.item.discount)) * Double(item.amount)
            }
            
        }
        return cost
    }
}


struct ShoppingCart_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCart(uvm: UserViewModel(), ivm: ItemViewModel())
    }
}
