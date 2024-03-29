//
//  BuyingView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 29.01.22.
//

import SwiftUI
import Stripe
import StripePaymentSheet

struct BuyingView: View {
    @StateObject var uvm: UserViewModel
    @Binding var showBuyingView: Bool
    @State private var paymentMethodParams: STPPaymentMethodParams?
    @ObservedObject private var pvm = PaymentViewModel()
    var body: some View {
        //Diese View wird angezeigt, wenn der Nutzer das erste mal auf den "Kaufen"-Knopf gedrückt hat.
        ZStack {
            ScrollView {
                ForEach(uvm.cartItems) { cartItem in
                    HStack {
                        Text("\(cartItem.amount) x")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        VStack(alignment: .leading) {
                            Text(cartItem.item.title)
                                .fontWeight(.bold)
                            Text(cartItem.item.id)
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 2)
                        Spacer()
                        Text("\(String(format: "%.2f", cartItem.item.discount != 0 ? (cartItem.item.price - (cartItem.item.price/100.0) * Double(cartItem.item.discount)): cartItem.item.price)) $")
                    }
                    .padding()
                }
            }
            
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 0.5, x: 0, y: -1)
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sum:")
                                    .fontWeight(.bold)
                                Text("\(String(format: "%.2f", pvm.calculateCost(items: uvm.cartItems)))$")
                                    .font(.subheadline)
                                Divider()
                                Text("Address:")
                                    .font(.body)
                                    .fontWeight(.bold)
                                Text("\(uvm.mainUser.lastName), \(uvm.mainUser.firstName)")
                                Text("\(uvm.mainUser.adress.street) \(uvm.mainUser.adress.number)")
                                Text("\(String(uvm.mainUser.adress.zipCode)) \(uvm.mainUser.adress.city)")
                                Text(uvm.mainUser.adress.land)
                            }
                            Spacer()
                        }
                        .padding()
                        VStack {
                          if let paymentSheet = pvm.paymentSheet {
                            PaymentSheet.PaymentButton(
                              paymentSheet: paymentSheet,
                              onCompletion: { result in
                                  //Der Bezahlvorgang wird beendet
                                  pvm.onPaymentCompletion(result: result)
                                  if let paymentResult = pvm.paymentResult {
                                      switch paymentResult {
                                      case .completed:
                                          print("Completed")
                                          Task {
                                              //An dieser Stelle wird der die Bestellung in der Datenbank hochgeladen und der Warenkorb wird gelöscht, um den Kaufvorgang zu beenden.
                                              await uvm.createOrder(price: pvm.calculateCost(items: uvm.cartItems))
                                              pvm.paymentIntentClientSecret = ""
                                          }
                                          withAnimation() {
                                              showBuyingView.toggle()
                                          }
                                      case .canceled:
                                          print("Payment canceled.")
                                      case .failed(let error):
                                          print("Payment failed: \(error.localizedDescription)")
                                      }
                                  }
                              }
                            ) {
                                Text("Pay with credit card")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width - 50)
                                    .background(.black)
                                    .cornerRadius(15, antialiased: false)
                            }
                          } else {
                            Text("Loading…")
                                  .foregroundColor(.white)
                                  .padding()
                                  .frame(width: UIScreen.main.bounds.width - 50)
                                  .background(.black)
                                  .cornerRadius(15, antialiased: false)
                          }
                          if let result = pvm.paymentResult {
                            switch result {
                            case .completed:
                              Text("Payment complete")
                            case .failed(let error):
                              Text("Payment failed: \(error.localizedDescription)")
                            case .canceled:
                              Text("Payment canceled.")
                            }
                          }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
                .onAppear { pvm.preparePaymentSheet(items: uvm.cartItems) }
                
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    //Der Kaufvorgang wird abgebrochen.
                    withAnimation() {
                        showBuyingView.toggle()
                    }
                    //Kaufvorgang mit Stripe stornieren, wenn sie noch nicht getätigt wurde, damit der Nutzer keine Zahlung tätigen muss.
                    pvm.cancelPayment()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing, content: {
                
                HStack {
                    Text("Payment process")
                        .fontWeight(.bold)
                    Image(systemName: "creditcard")
                        .font(.subheadline)
                }
            })
        }
        }
    }
    


struct BuyingView_Previews: PreviewProvider {
    static var previews: some View {
        BuyingView(uvm: UserViewModel(), showBuyingView: .constant(true))
    }
}


//PaymentButton(payBtnAction: {
//
//}, price: String(format: "%.2f", calculateCost(items: uvm.cartItems)))
//    .frame(width: UIScreen.main.bounds.width - 50)
//    .padding([.horizontal,.bottom])
//    .alert(uvm.alertMessage, isPresented: $uvm.showAlert) {
//        Button("OK", role: .cancel) {
//            withAnimation() {
//                showBuyingView.toggle()
//            }
//        }
//    }
