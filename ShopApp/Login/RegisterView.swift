//
//  RegisterView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 13.01.22.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var lvm: LoginViewModel
    var body: some View {
        VStack {
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
                        .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                        .onTapGesture {
                            lvm.picker.toggle()
                        }
                        .sheet(isPresented: $lvm.picker, content: {
                            ImagePicker(picker: $lvm.picker, img_Data: $lvm.image_Data)
                        })
                    Image(systemName: "person")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
            

            TextField("firstname", text: $lvm.firstName)
            TextField("lastName", text: $lvm.lastName)
            DatePicker("birthday", selection: $lvm.birthday)
            TextField("street", text: $lvm.address.street)
            TextField("number", text: $lvm.address.number)
            TextField("zipcode", value: $lvm.address.zipCode, formatter: NumberFormatter())
                .keyboardType(UIKeyboardType.decimalPad)
            TextField("city", text: $lvm.address.city)
            TextField("land", text: $lvm.address.land)
            Button(action: {
                lvm.registerNewUserData()
            }, label: {
                Text("Register")
            })

        }
        
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(lvm: LoginViewModel())
    }
}
