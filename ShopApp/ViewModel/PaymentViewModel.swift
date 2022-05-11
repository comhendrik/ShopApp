//
//  PaymentViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 11.05.22.
//

import Stripe
import SwiftUI

//Makes it possible to create payments with stripe

struct CheckoutIntentResponse: Decodable {
    let clientSecret: String
}

class PaymentGatewayController: UIViewController {
    
    private var paymentIntentClientSecret: String?
    
    public var message: String = ""
    
    func startCheckout() {
       print("checkout")
        let url = URL(string: "http://127.0.0.1:5000/create-payment-intent")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.httpBody = try! JSONEncoder().encode(cart.items)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200
            else {
                return
            }
            
            let checkoutIntentResponse = try? JSONDecoder().decode(CheckoutIntentResponse.self, from: data)
            self.paymentIntentClientSecret = checkoutIntentResponse?.clientSecret
        }.resume()
        
        print("end checkout")
        
    }
    
    func submitPayment(intent: STPPaymentIntentParams, completion: @escaping (STPPaymentHandlerActionStatus, STPPaymentIntent?, NSError?) -> Void) {
        
        let paymentHandler = STPPaymentHandler.shared()
        
        paymentHandler.confirmPayment(intent, with: self) { (status, intent, error) in
            completion(status, intent, error)
        }
        
    }
    
    func pay(paymentMethodParams: STPPaymentMethodParams?) {
        if paymentMethodParams == nil {
            print("error with params")
            return
        }
        if self.paymentIntentClientSecret == nil {
            return
        }
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: self.paymentIntentClientSecret!)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        submitPayment(intent: paymentIntentParams) { status, intent, error in
            
            switch status {
                case .failed:
                    self.message = "Failed"
                case .canceled:
                    self.message = "Cancelled"
                case .succeeded:
                    self.message = "Your payment has been successfully completed!"
            }
            
        }
        
    }
    
}

extension PaymentGatewayController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
          return self
      }
}
