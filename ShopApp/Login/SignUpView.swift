//
//  SignUpView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 13.01.22.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var lvm: LoginViewModel
    var body: some View {
        TextField("email", text: $lvm.email_SignUp)
            .textInputAutocapitalization(TextInputAutocapitalization.never)
        TextField("password", text: $lvm.password_SignUp)
        TextField("repassword", text: $lvm.reEnterPassword)
        Button(action: {
            lvm.SignUp()
        }, label: {
            Text("signup")
        })
            .alert(lvm.alertMsg, isPresented: $lvm.alert) {
                Button("OK", role: .cancel) { }
            }
        Button(action: {
            lvm.signUpView.toggle()
        }, label: {
            Text("already an account ? log in!")
        })
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(lvm: LoginViewModel())
    }
}
