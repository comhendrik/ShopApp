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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(lvm: LoginViewModel())
    }
}
