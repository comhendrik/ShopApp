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
        ScrollView(showsIndicators: false) {
            //UI zum Account erstellen.
            Text("Welcome!")
                .fontWeight(.bold)
            Spacer()
            Image("USE-OWN-IMAGE!")
                .scaledToFit()
            LoginTextField(isSecure: false, value: $lvm.firstName, title: "firstname", systemImage: "person.crop.square.fill")
            LoginTextField(isSecure: false, value: $lvm.lastName, title: "lastname", systemImage: "")
            LoginTextField(isSecure: false, value: $lvm.email_SignUp, title: "email", systemImage: "envelope")
            LoginTextField(isSecure: true, value: $lvm.password_SignUp, title: "password", systemImage: "lock")
            LoginTextField(isSecure: true, value: $lvm.reEnterPassword, title: "re enter password", systemImage: "lock")
            Button(action: {
                //Account erstellung
                lvm.SignUp()
            }, label: {
                Text("SignUp!")
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
                //Anzeigen der AnmeldeView
                withAnimation() {
                    lvm.signUpView.toggle()
                }
            }, label: {
                Text("you have an account? login!")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.gray.opacity(0.05))
                    .cornerRadius(15, antialiased: false)
            })
        }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(lvm: LoginViewModel())
    }
}
