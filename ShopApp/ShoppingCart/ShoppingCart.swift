//
//  ShoppingCart.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct ShoppingCart: View {
    @StateObject var uvm: UserViewModel
    @State private var showBuyingView = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    //Wenn Artikel im Warenkorb vorhanden sind, werden diese in einer Liste angezeigt und außerdem besteht die Möglichkeit die Artikel zu kaufen.
                    if uvm.cartItems.count > 0 {
                        ShoppingCartListView(uvm: uvm)
                        PaymentButton(payBtnAction: {
                            //Bei Druck auf diesen Button werden die Artikel noch nicht gekauft, sondern es wird zuerst eine View angezeigt mit Information über die Bestellung
                            withAnimation(.easeIn(duration: 1)) {
                                showBuyingView.toggle()
                            }
                        }, price: String(format: "%.2f", calculateCost(items: uvm.cartItems)))
                            .disabled(showBuyingView || uvm.cartItems.count <= 0)
                        NavigationLink(isActive: $showBuyingView) {
                            BuyingView(uvm: uvm, showBuyingView: $showBuyingView)
                        } label: {
                            EmptyView()
                        }
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
                    
                }
                .blur(radius: showBuyingView ? 3 : 0)
                //Diese View wird angezeigt, wenn ein Nutzer etwas kaufen möchte.
                
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
