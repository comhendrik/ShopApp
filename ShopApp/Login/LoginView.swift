//
//  LoginView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 12.01.22.
//

import SwiftUI

struct LoginView: View {
    @StateObject var lvm: LoginViewModel
    @State private var showResetPasswordView = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text("Welcome!")
                .fontWeight(.bold)
            Image("people-shopping-2")
                .scaledToFit()
                .padding()
            Spacer()
            if showResetPasswordView {
                ResetPasswordView(showResetPasswordview: $showResetPasswordView, lvm: lvm)
            } else {
                LoginTextField(isSecure: false, value: $lvm.email, title: "email", systemImage: "envelope")
                LoginTextField(isSecure: true, value: $lvm.password, title: "password", systemImage: "lock")
                Button(action: {
                    lvm.login()
                }, label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.black)
                        .cornerRadius(15, antialiased: false)
                })
                    .alert(lvm.alertMsg, isPresented: $lvm.alert) {
                        Button("OK", role: .cancel) { }
                    }
                Button(action: {
                    withAnimation() {
                        lvm.signUpView.toggle()
                    }
                }, label: {
                    Text("no account ? signup!")
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.gray.opacity(0.05))
                        .cornerRadius(15, antialiased: false)
                })
                Button(action: {
                    withAnimation() {
                        showResetPasswordView.toggle()
                    }
                }, label: {
                    Text("Forgot password?")
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.gray.opacity(0.05))
                        .cornerRadius(15, antialiased: false)
                })
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(lvm: LoginViewModel())
    }
}
