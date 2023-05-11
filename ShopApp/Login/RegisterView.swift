//
//  RegisterView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 13.01.22.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var lvm: LoginViewModel
    @FocusState private var isFocused: Bool
    let isRegisterView: Bool
    var body: some View {
        //UI zum Ändern und Eingeben der Adresse.
        VStack {
            Text(isRegisterView ? "Please tell us your address:" : "Update your address:")
                .fontWeight(.bold)
                .font(.largeTitle)
            Spacer()
            LoginTextField(isSecure: false, value: $lvm.address.street, title: "street", systemImage: "person.text.rectangle", viewWidth: nil)
            LoginTextField(isSecure: false, value: $lvm.address.number, title: "number", systemImage: "", viewWidth: nil)
            //Extra Erstellung eines TextFields, da wir mit einem Integer umgehen wollen.
            TextField("zipcode", value: $lvm.address.zipCode, formatter: NumberFormatter())
                .textInputAutocapitalization(TextInputAutocapitalization.never)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 15).stroke().foregroundColor(isFocused ? .black : .gray))
                .frame(width: UIScreen.main.bounds.width - 50)
                .focused($isFocused)
                .keyboardType(UIKeyboardType.decimalPad)
            LoginTextField(isSecure: false, value: $lvm.address.city, title: "city", systemImage: "", viewWidth: nil)
            LoginTextField(isSecure: false, value: $lvm.address.land, title: "land", systemImage: "", viewWidth: nil)
            Spacer()
            Button(action: {
                //Wird die View beim Registrationsvorgang verwenden muss lvm.registerNewUserData() ausgeführt werden. Wird die View zur Änderung der Adresse verwendet muss lvm.updateUserAddress() ausgeführt werden.
                if isRegisterView {
                    lvm.registerNewUserData()
                } else {
                    lvm.updateUserAddress()
                    
                }
            }, label: {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.black)
                    .cornerRadius(15, antialiased: false)
            })
                .alert(lvm.alertMsg, isPresented: $lvm.alert) {
                    Button("OK", role: .cancel) { }
                }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(lvm: LoginViewModel(), isRegisterView: true)
    }
}
