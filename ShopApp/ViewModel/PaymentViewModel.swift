//
//  PaymentViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 11.05.22.
//

import Stripe
import SwiftUI

//Makes it possible to create payments with stripe


class PaymentViewModel: ObservableObject {
  let backendCheckoutUrl = URL(string: "http://127.0.0.1:5000/payment")! // Your backend endpoint
    let backendDeleteUrlString = "http://127.0.0.1:5000/cancel-payment"
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?
    @Published var paymentIntentClientSecret: String = ""

    func preparePaymentSheet(items: [CartItem]) {
    // MARK: Fetch the PaymentIntent and Customer information from the backend
      print("hello")
    var request = URLRequest(url: backendCheckoutUrl)
    request.httpMethod = "POST"
      request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      let amount = calculateCost(items: items)
      let bodydata = ["price": amount]
      let jsonData = try? JSONSerialization.data(withJSONObject: bodydata, options: .fragmentsAllowed)
      request.httpBody = jsonData
      
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            //let customerId = json["customer"] as? String,
            //let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                let clientSecret = json["paymentIntent"] as? String,
            let self = self else {
        // Handle error
        return
      }

      STPAPIClient.shared.publishableKey = "pk_test_51KwkR2ELibbweCsHNHiDdSCz2gPFnFWN7rmbIAQ0go5tBKT294iFMxaTPngS58OREXSYekn81fRhfquyBUOP5E1y003smaKoFM"
      // MARK: Create a PaymentSheet instance
      var configuration = PaymentSheet.Configuration()
      configuration.merchantDisplayName = "Example, Inc."
      configuration.primaryButtonColor = .black

      DispatchQueue.main.async {
          //Display Payment Sheet
          self.paymentIntentClientSecret = clientSecret
          self.paymentSheet = PaymentSheet(paymentIntentClientSecret: self.paymentIntentClientSecret, configuration: configuration)
          
      }
    })
    task.resume()
  }

  func onPaymentCompletion(result: PaymentSheetResult) {
    self.paymentResult = result
      
  }
    
    
    func cancelPayment() {
        if self.paymentIntentClientSecret != "" {
            let id = STPPaymentIntentParams(clientSecret: self.paymentIntentClientSecret).stripeId
            if id == nil {
                print("error: payment does not exits")
                return
            }
            guard let requestURL = URL(string: backendDeleteUrlString+"/\(id!)") else {
                print("error with url")
                return
            }
            var request = URLRequest(url:  requestURL)
            
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request) { data, res, error in
                if error != nil {
                    print(error!)
                    return
               }
               else if let data = data {
                   let result = String(decoding: data, as: UTF8.self)
                   if result == "success" {
                       print("success")
                   } else {
                       print("error from server")
                       return
                   }
               }
            }
            task.resume()
        }
    }
    
    
    func calculateCost(items: [CartItem]) -> Double {
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
