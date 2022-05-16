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
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
