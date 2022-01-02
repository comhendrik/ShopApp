//
//  ShopAppApp.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//

import SwiftUI
import Firebase

@main
struct ShopAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
