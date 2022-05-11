//
//  ShopAppApp.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//

import SwiftUI
import Firebase
import Stripe

@main
struct ShopAppApp: App {
    //Firebase wird in dieser Datei initialisiert, außerdem enthält sie die ContentView
    init() {
        FirebaseApp.configure()
        StripeAPI.defaultPublishableKey = "pk_test_51KwkR2ELibbweCsHNHiDdSCz2gPFnFWN7rmbIAQ0go5tBKT294iFMxaTPngS58OREXSYekn81fRhfquyBUOP5E1y003smaKoFM"
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
