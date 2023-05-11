//
//  LoginTextField.swift
//  ShopApp
//
//  Created by Hendrik Steen on 23.01.22.
//

import SwiftUI

struct LoginTextField: View {
    let isSecure: Bool
    @Binding var value: String
    let title: String
    let systemImage: String
    @FocusState private var isFocused: Bool
    @State private var showSecureField = true
    let viewWidth: CGFloat?
    var body: some View {
        //UI für das Design des Textfeldes.
        VStack(alignment: .leading) {
            if systemImage != "" {
                Image(systemName: systemImage)
                    .foregroundColor(isFocused ? .black : .gray)
                    .padding()
            }
            //Bei Benutzung kann übergeben werden, ob es ein SecureField oder normales TextField sein soll.
            if isSecure {
                HStack {
                    if showSecureField {
                        SecureField(title, text: $value)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(TextInputAutocapitalization.never)
                            .focused($isFocused)
                    } else {
                        TextField(title, text: $value)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(TextInputAutocapitalization.never)
                            .focused($isFocused)
                    }
                    Button(action: {
                        withAnimation() {
                            showSecureField.toggle()
                        }
                    }, label: {
                        Image(systemName: showSecureField ? "eye" : "eye.slash")
                            .foregroundColor(isFocused ? .black : .gray)
                    })
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 15).stroke().foregroundColor(isFocused ? .black : .gray))
                .frame(width: viewWidth == nil ? UIScreen.main.bounds.width - 55 : viewWidth)
            } else {
                
                TextField(title, text: $value)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(TextInputAutocapitalization.never)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke().foregroundColor(isFocused ? .black : .gray))
                    .frame(width: viewWidth == nil ? UIScreen.main.bounds.width - 55 : viewWidth)
                    .focused($isFocused)
            }
        }
    }
}

struct LoginTextField_Previews: PreviewProvider {
    static var previews: some View {
        LoginTextField(isSecure: false, value: .constant("Hello"), title: "email", systemImage: "envelope", viewWidth: nil)
    }
}
