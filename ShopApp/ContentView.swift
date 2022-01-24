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
        if lvm.isLoading {
            ProgressView()
        } else {
            if status {
                ShopView(lvm: lvm)
            } else {
                if statusofregister {
                    VStack {
                        RegisterView(lvm: lvm)
                        Button(action: {
                            withAnimation() {
                                statusofregister.toggle()
                            }
                            lvm.logOut()
                        }, label: {
                            Text("Logout")
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 50)
                                .background(.gray.opacity(0.05))
                                .cornerRadius(15, antialiased: false)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
