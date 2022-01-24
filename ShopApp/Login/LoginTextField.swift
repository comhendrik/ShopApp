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
    var body: some View {
        VStack(alignment: .leading) {
            if systemImage != "" {
                Image(systemName: systemImage)
                    .foregroundColor(isFocused ? .black : .gray)
                    .padding()
            }
            if isSecure {
                HStack {
                    if showSecureField {
                        SecureField(title, text: $value)
                            .textInputAutocapitalization(TextInputAutocapitalization.never)
                            .focused($isFocused)
                    } else {
                        TextField(title, text: $value)
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
                .frame(width: UIScreen.main.bounds.width - 50)
            } else {
                
                TextField(title, text: $value)
                    .textInputAutocapitalization(TextInputAutocapitalization.never)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke().foregroundColor(isFocused ? .black : .gray))
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .focused($isFocused)
            }
        }
    }
}

struct LoginTextField_Previews: PreviewProvider {
    static var previews: some View {
        LoginTextField(isSecure: false, value: .constant("Hello"), title: "email", systemImage: "envelope")
    }
}
