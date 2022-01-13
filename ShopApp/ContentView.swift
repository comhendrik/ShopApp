//
//  ContentView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//

import SwiftUI

struct ContentView: View {

    @StateObject var lvm = LoginViewModel()
    @AppStorage("log_status") var status = false
    @AppStorage("current_status") var statusofregister = false
    var body: some View {
        if status {
            ShopView(lvm: lvm)
        } else {
            if statusofregister {
                VStack {
                    RegisterView(lvm: lvm)
                    Button(action: {
                        statusofregister.toggle()
                    }, label: {
                        Text("go back")
                    })
                }
            } else {
                if lvm.signUpView {
                    SignUpView(lvm: lvm)
                } else {
                    LoginView(lvm: lvm)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
