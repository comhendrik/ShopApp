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
                            Text("Add some items to your cart \nBut most importantly, have fun shopping!")
                                .multilineTextAlignment(.center)
                                .font(.title3)
                            Image(systemName: "cart.badge.plus")
                                .font(.largeTitle)
                            Spacer()
                        }
                    }
                    VStack {
                        HStack {
                            Text("delivery date:")
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(getDeliverDate())")
                        }
                        HStack {
                            Text("Sum:")
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(String(format: "%.2f", calculateCost(items: uvm.cartItems)))$")
                            
                        }
                    }
                    .padding(.horizontal)
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
    
    private func getDeliverDate() -> String {
        //Normal delivery within 3 days
        Calendar.current.date(byAdding: .day, value: 7, to: Date())?.formatted(date: .numeric, time: .omitted) ?? "no date available"
    }
}


struct ShoppingCart_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCart(uvm: UserViewModel())
    }
}
