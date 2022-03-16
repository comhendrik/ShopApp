//
//  BuyingView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 29.01.22.
//

import SwiftUI

struct BuyingView: View {
    @StateObject var uvm: UserViewModel
    @Binding var showBuyingView: Bool
    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "creditcard")
                            .font(.subheadline)
                        Text("Payment process")
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Button {
                        withAnimation() {
                            showBuyingView.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
                .padding()
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Address:")
                            .font(.body)
                            .fontWeight(.bold)
                        Text("\(uvm.mainUser.lastName), \(uvm.mainUser.firstName)")
                        Text("\(uvm.mainUser.adress.street) \(uvm.mainUser.adress.number)")
                        Text("\(String(uvm.mainUser.adress.zipCode)) \(uvm.mainUser.adress.city)")
                        Text(uvm.mainUser.adress.land)
                    }
                    .font(.subheadline)
                    Spacer()
                }
                .padding()
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Method:")
                            .fontWeight(.bold)
                        Text("Invoice")
                    }
                    Spacer()
                }
                .padding()
                PaymentButton(addAction: {
                    Task {
                        //Create Order
                        await uvm.createOrder(price: calculateCost(items: uvm.cartItems))
                    }
                }, price: String(format: "%.2f", calculateCost(items: uvm.cartItems)))
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .padding([.horizontal,.bottom])
                    .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
                        Button("OK", role: .cancel) {
                            withAnimation() {
                                showBuyingView.toggle()
                            }
                        }
                    }
            }
                .background(Color.white)
                .foregroundColor(.black)
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

struct BuyingView_Previews: PreviewProvider {
    static var previews: some View {
        BuyingView(uvm: UserViewModel(), showBuyingView: .constant(true))
    }
}
