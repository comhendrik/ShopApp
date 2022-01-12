//
//  LoginViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 12.01.22.
//

import Foundation
import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isSignUp = false
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
    @Published var number = ""
    @Published var resetEmail = ""
    @Published var isLinkSend = false
    @Published var isLoading = false
    @Published var signUpView = false
    
    
    
    @Published var firstName = ""
    @Published var middleName = ""
    @Published var lastName = ""
    @Published var image_Data = Data(count: 0)
    @Published var picker = false
    
    
    
    @Published var alert = false
    @Published var alertMsg = ""
    
    @AppStorage("log_status") var status = false
    @AppStorage("current_status") var statusofregister = false
    
    let db = Firestore.firestore()
    
    func UploadImage(imageData: Data, path: String, completion: @escaping (String) -> ()) {
        let storage = Storage.storage()
        let ref = storage.reference()
        let uid = Auth.auth().currentUser!.uid
        ref.child(path).child(uid).putData(imageData, metadata: nil) { (_, err) in
            if err != nil {
                completion("")
                return
            }
            
            ref.child(path).child(uid).downloadURL { (url, err) in
                if err != nil {
                    completion("")
                    return
                }
                completion("\(url!)")
            }
        }
    }
    
    func registerNewUserData() {
        if let phoneNumber = Int(number) {
            let uid = Auth.auth().currentUser!.uid
            UploadImage(imageData: image_Data, path: "profile_Photos") { (url) in
                
                self.db.collection("Users").document(uid).setData([
                    "uid":uid,
                    "imgurl": url,
                    "firstName": self.firstName,
                    "middleName": self.middleName,
                    "lastName": self.lastName,
                    "email": Auth.auth().currentUser?.email ?? "errormail@notreal.com",
                    "number": phoneNumber
                ]) {
                    (err) in
                    if err != nil {
                        self.isLoading = false
                        return
                    }
                    self.isLoading = false
                    self.status = true
                }
            }
            
            statusofregister = false
        } else {
            return
        }

    }
    
    func resetPassword() {
        resetEmail = email
        if resetEmail != "" {
            Auth.auth().sendPasswordReset(withEmail: resetEmail) { (err) in
                if err != nil {
                    self.alertMsg = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.alertMsg = "Reset Email has been sent. Check all your folders its maybe in the spam folder"
                self.alert.toggle()
            }
        } else {
            self.alertMsg = "Please select an email"
            self.alert.toggle()
        }
    }
    
    func login() {
        
        if email == "" || password == "" {
            self.alertMsg = "Fill the contents properly"
            self.alert.toggle()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            let user = Auth.auth().currentUser
            
//            if !user!.isEmailVerified {
//                self.alertMsg = "Please verify"
//                self.alert.toggle()
//
//                do {
//                   try Auth.auth().signOut()
//                } catch {
//                    print(error)
//                }
//                return
//
//            } else {
//                self.status = true
//            }
            
//            self.db.collection("Users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid ).getDocuments { (snap, err) in
//                self.isLoading = true
//                if err != nil {
//                    self.statusofregister.toggle()
//                    self.isLoading = false
//                    return
//                }
//
//                if snap!.documents.isEmpty {
//                    self.statusofregister.toggle()
//                    self.isLoading = false
//                    return
//                }
//
//                self.statusofregister = false
//                self.status = true
//                self.isLoading = false
//            }
        }
            self.status = true
    }
    
    func SignUp() {
        
        if email_SignUp == "" || password_SignUp == "" || reEnterPassword == "" {
            self.alertMsg = "Fill Content properly"
            self.alert.toggle()
            return
        }
        
        if password_SignUp != reEnterPassword {
            self.alertMsg = "password missmatch"
            self.alert.toggle()
            return
        }
        
        Auth.auth().createUser(withEmail: email_SignUp, password: password_SignUp) { (res, err) in
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            res?.user.sendEmailVerification(completion: { (err) in
                if err != nil {
                    self.alertMsg = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.alertMsg = "Verify Link has been sent. Verify your email"
                self.alert.toggle()
                
            })
        }
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        
        self.status = false
        self.statusofregister = false
        
        email = ""
        password = ""
        email_SignUp = ""
        password_SignUp = ""
        reEnterPassword = ""
        
    }
}
