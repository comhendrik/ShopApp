//
//  ContentView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 28.11.21.
//

import SwiftUI

struct ContentView: View {
    //Innerhalb dieser View wird geregelt, welche View angezeigt werden muss
    @StateObject var lvm = LoginViewModel()
    @AppStorage("log_status") var status = false
    @AppStorage("current_status") var statusofregister = false
    var body: some View {
        if status {
            //status sorgt dafür, ob der Login Prozess angezeigt wird oder der normale Shop
            ShopView(lvm: lvm)
        } else {
            //Die Views für den Loginvorgang finden sich in dem Ordner Login.
            if statusofregister {
                //ist statusofregister == true, dann wird die view angezeigt, um sich mit mehreren Daten, wie Adresse zu registrieren.
                VStack {
                    RegisterView(lvm: lvm, isRegisterView: true)
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
                    //Der User kann sich anmelden, aber auch registrieren. Welche View gezeigt wird, wird über lvm.signUpView gesteuert.
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
