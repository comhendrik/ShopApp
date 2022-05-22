//
//  PaymentViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 11.05.22.
//

import Stripe
import SwiftUI

//Zahlung über Stripe werden über dieses ViewModel abgewickelt


class PaymentViewModel: ObservableObject {
    let backendCheckoutUrl = URL(string: "http://127.0.0.1:5000/payment")! // backend endpoint
    let backendDeleteUrlString = "http://127.0.0.1:5000/cancel-payment"
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published var paymentIntentClientSecret: String = ""

    func preparePaymentSheet(items: [CartItem]) {
        // Ein PaymentIntent über diesen POST Request erstellt.
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //Als body wird der Price mitgegeben, weil Stripe nur die Information des Preise braucht, damit eine Zahlung stattfinden kann.
        let amount = calculateCost(items: items)
        let bodydata = ["price": amount]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodydata, options: .fragmentsAllowed)
        request.httpBody = jsonData
          
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            //Der Server gibt die Daten des PaymentIntent nach dem Request zurück, wichtig ist das ClientSecret, damit die Zahlung abgeschlossen werden kann.
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let clientSecret = json["paymentIntent"] as? String,
                  let self = self else {
                      //TODO: Handle error
                      return
                  }

            STPAPIClient.shared.publishableKey = "YOURPUBLISHABLEAPIKEY"
            // Instanz eines PaymentSheets wird erstellt
            var configuration = PaymentSheet.Configuration()
            configuration.primaryButtonColor = .black
            

            DispatchQueue.main.async {
                //Payment Sheet wird angezeigt, da es sich um UI-Änderungen handelt, muss dies auf dem Mainthread geschehen
                self.paymentIntentClientSecret = clientSecret
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: self.paymentIntentClientSecret, configuration: configuration)
            }
        })
        task.resume()
    }

    func onPaymentCompletion(result: PaymentSheetResult) {
        //Diese Funktion übergibt das Result der Zahlung an das ViewModel, damit die View entweder geschlossen wird und die Daten in der Datenbank Firestore überschrieben werden oder das die View offen bleibt und den Fehler anzeigt.
        self.paymentResult = result
    }
    
    
    func cancelPayment() {
        //TODO: handle errors in this function properly with alert or something else
        //Diese Funktion ermöglicht das Löschen eines Intent
        //Zuerst wird überprüft, ob ein clientSecret von Stripe noch vorhanden ist, wenn ja wissen wir das bei schließen des Kaufvorgangs dieser gelöscht werden muss, ist dem nicht so muss beim Schließen der View nichts passieren.
        if self.paymentIntentClientSecret != "" {
            //Die Id des Intent muss an den Server übergeben werden, damit der gewünschte Intent gelöscht wird.
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
                   //Der Server gibt die Antwort in Form eines Strings wieder, dementsprechend kann gehandelt werden.
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
        //Diese berechnet die Kosten aller Items, um diesen dem Server per POST Request mit zu teilen. siehe Zeile
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
