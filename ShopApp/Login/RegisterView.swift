//
//  RegisterView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 13.01.22.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var lvm: LoginViewModel
    @State private var showFirst = true
    var body: some View {
        if showFirst {
            FirstRegisterView(lvm: lvm, showFirst: $showFirst)
        } else {
            SecondRegisterView(lvm: lvm, showFirst: $showFirst)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(lvm: LoginViewModel())
    }
}

struct FirstRegisterView: View {
    @StateObject var lvm: LoginViewModel
    @Binding var showFirst: Bool
    var body: some View {
        VStack {
            Text("Information:")
                .fontWeight(.bold)
                .font(.largeTitle)
            Spacer()
            if lvm.image_Data.count != 0 {
                Image(uiImage: (UIImage(data: lvm.image_Data))!)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                    .onTapGesture {
                        lvm.picker.toggle()
                    }
                    .sheet(isPresented: $lvm.picker, content: {
                        ImagePicker(picker: $lvm.picker, img_Data: $lvm.image_Data)
                    })
            } else {
                ZStack {
                    Circle()
                        .foregroundColor(.gray.opacity(0.05))
                        .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                        .onTapGesture {
                            lvm.picker.toggle()
                        }
                        .sheet(isPresented: $lvm.picker, content: {
                            ImagePicker(picker: $lvm.picker, img_Data: $lvm.image_Data)
                        })
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
            LoginTextField(isSecure: false, value: $lvm.firstName, title: "firstname", systemImage: "person.crop.square.fill")
            LoginTextField(isSecure: false, value: $lvm.lastName, title: "lastname", systemImage: "")
            Text("Birthday:")
                .font(.subheadline)
                .fontWeight(.bold)
            DatePicker("", selection: $lvm.birthday, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
            Spacer()
            Button(action: {
                withAnimation() {
                    showFirst = false
                }
            }, label: {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.black)
                    .cornerRadius(15, antialiased: false)
            })
        }
    }
}

struct SecondRegisterView: View {
    @StateObject var lvm: LoginViewModel
    @FocusState private var isFocused: Bool
    @Binding var showFirst: Bool
    var body: some View {
        VStack {
            Text("Your address:")
                .fontWeight(.bold)
                .font(.largeTitle)
            Spacer()
            LoginTextField(isSecure: false, value: $lvm.address.street, title: "street", systemImage: "person.text.rectangle")
            LoginTextField(isSecure: false, value: $lvm.address.number, title: "number", systemImage: "")
            TextField("zipcode", value: $lvm.address.zipCode, formatter: NumberFormatter())
                .textInputAutocapitalization(TextInputAutocapitalization.never)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 15).stroke().foregroundColor(isFocused ? .black : .gray))
                .frame(width: UIScreen.main.bounds.width - 50)
                .focused($isFocused)
                .keyboardType(UIKeyboardType.decimalPad)
            LoginTextField(isSecure: false, value: $lvm.address.city, title: "city", systemImage: "")
            LoginTextField(isSecure: false, value: $lvm.address.land, title: "land", systemImage: "")
            Spacer()
            Button(action: {
                lvm.registerNewUserData()
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
            Button(action: {
                withAnimation() {
                    showFirst = true
                }
            }, label: {
                Text("Back")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.gray.opacity(0.05))
                    .cornerRadius(15, antialiased: false)
            })
        }
    }
}
