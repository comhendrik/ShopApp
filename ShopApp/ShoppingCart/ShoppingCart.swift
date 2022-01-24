//
//  ShoppingCart.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCart: View {
    @StateObject var uvm: UserViewModel
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if uvm.cartItems.count > 0 {
                        ShoppingCartListView(uvm: uvm)
                    } else {
                        VStack {
                            Spacer()
                            Text("Empty Cart")
                                .font(.title3)
                            Image(systemName: "cart.fill")
                                .font(.largeTitle)
                            Spacer()
                        }
                    }
                    Text("\(String(format: "%.2f", calculateCost(items: uvm.cartItems)))$")
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding()
                    PaymentButton(addAction: {
                        //Normale Lieferung in 3 Tage
                        uvm.createOrders(price: calculateCost(items: uvm.cartItems), deliveryDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date.now)
                    })
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .padding(.horizontal)
                        .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                            Button("OK", role: .cancel) { }
                        }
                }
                
                }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("Cart")
                            .font(.title)
                            .fontWeight(.bold)
                        Image(systemName: "cart")
                            .font(.title)
                            
                    }
                }
            }
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
        ShoppingCart(uvm: UserViewModel())
    }
}
