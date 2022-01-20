//
//  LoginView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 12.01.22.
//

import SwiftUI

struct LoginView: View {
    @StateObject var lvm: LoginViewModel
    var body: some View {
        TextField("email", text: $lvm.email)
            .textInputAutocapitalization(TextInputAutocapitalization.never)
        TextField("password", text: $lvm.password)
        Button(action: {
            lvm.login()
        }, label: {
            Text("Login")
        })
            .alert(lvm.alertMsg, isPresented: $lvm.alert) {
                Button("OK", role: .cancel) { }
            }
        Button(action: {
            lvm.signUpView.toggle()
        }, label: {
            Text("no account ? signup!")
        })
        Button(action: {
            lvm.resetPassword()
        }, label: {
            Text("Forgot password? Please type your email in the field above")
        })

        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(lvm: LoginViewModel())
    }
}
