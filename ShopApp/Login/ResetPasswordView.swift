//
//  ResetPasswordView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 23.01.22.
//

import SwiftUI

struct ResetPasswordView: View {
    @Binding var showResetPasswordview: Bool
    @StateObject var lvm: LoginViewModel
    var body: some View {
        LoginTextField(isSecure: false, value: $lvm.email, title: "email", systemImage: "envelope", viewWidth: nil)
        Spacer()
        Button(action: {
            //Passwort zurücksetzen
            lvm.resetPassword()
        }, label: {
            Text("Reset")
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
                //Anzeigen der LoginView
                showResetPasswordview.toggle()
            }
        }, label: {
            Text("Dismiss")
                .foregroundColor(.black)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 50)
                .background(.gray.opacity(0.05))
                .cornerRadius(15, antialiased: false)
        })
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(showResetPasswordview: .constant(true), lvm: LoginViewModel())
    }
}
