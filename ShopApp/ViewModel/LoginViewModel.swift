//
//  LoginViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 12.01.22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    //Dieses ViewModel ermöglicht eine Anmeldung über Firebase Authentication.
    //Wir brauchen mehrere Daten:
    
    //Login
    
    @Published var email = ""
    @Published var password = ""
    
    //Signup
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
    
    //PasswordReset
    @Published var resetEmail = ""
    
    //Diese Variable sorgt dafür, dass die richtige View angezeigt wird. Je nach dem, ob sich der Nutzer anmelden möchte, oder auch registrieren möchte
    @Published var signUpView = false
    
    
    //Um sich weiter zu registrieren wird Vorname und Nachname, sowie Geburtstag und Addresse als auch ein Profilbild gebraucht.
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var address = Address(_city: "", _zipCode: 0, _street: "", _number: "", _land: "")
    @Published var picker = false
    
    //Um Fehler anzuzeigen, wird ein Alert verwendet
    @Published var alert = false
    @Published var alertMsg = ""
    
    //Siehe Erklärung ContentView:
    @AppStorage("log_status") var status = false
    @AppStorage("current_status") var statusofregister = false
    
    let db = Firestore.firestore()
    
    func registerNewUserData() {
        //Überprüfe, ob alle Daten vorhanden sind
        if firstName == "" || lastName == "" {
            alertMsg = "Please tell us your name and make sure that you filled all fields."
            alert.toggle()
            return
        }
        if address.zipCode == 0 {
            alertMsg = "Please use a valid zipcode and make sure that you filled all fields."
            alert.toggle()
            return
        }
        if address.street == "" || address.number == "" || address.city == "" || address.land == "" {
            alertMsg = "Please tell us your address and make sure that you filled all fields."
            alert.toggle()
            return
        }
        if Auth.auth().currentUser == nil {
            alertMsg = "There are problems with your account. Please make sure that you are logged in."
            alert.toggle()
            return
        }
        let uid = Auth.auth().currentUser!.uid
        //Die Collection "Users" enthählt alle Nutzer mit den wichtigen Daten.
        self.db.collection("Users").document(uid).setData([
            "uid":uid,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "memberStatus": "Bronze",
            "street": self.address.street,
            "number": self.address.number,
            "city": self.address.city,
            "zipcode": self.address.zipCode,
            "land": self.address.land,
            "email": Auth.auth().currentUser?.email ?? "errormail@notreal.com",
        ]) {
            (err) in
            if err != nil {
                
                return
            }
            //Status kann auf true gesetzt werden, da sich der Nutzer registriert hat und der Shop angezeigt werden soll.
            self.status = true
        }
        //statusofregister kann auf false gesetzt werden, da sich der Nutzer registriert hat und der Shop angezeigt werden soll.
        statusofregister = false
    }
    
    func resetPassword() {
        //Diese Funktion ermöglicht das Zurücksetzen des Passworts.
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
        //Diese Funktion ermöglicht ein Login
        //Zuerst wird überpüft, ob email und Passwort und eingegeben wurden.
        if email == "" || password == "" {
            self.alertMsg = "Fill the contents properly"
            self.alert.toggle()
            return
        }
        //signIn per Firebase Auth
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            let user = Auth.auth().currentUser
            //Der Nutzer muss sich per Email verifizieren, ist dem nicht so wird ein Alert getriggert und der User wird ausgeloggt.
            if !user!.isEmailVerified {
                self.alertMsg = "Please verify"
                self.alert.toggle()
                do {
                   try Auth.auth().signOut()
                } catch {
                    print(error)
                }
                return
            }
            //Überprüfen, ob es ein Dokument in der "User" Collection gibt.
            self.db.collection("Users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid ).getDocuments { (snap, err) in
                if err != nil {
                    self.statusofregister = true
                    return
                }
                if snap!.documents.isEmpty {
                    //Gibt es kein Dokument wird statusofregister auf true gesetzt, damit sich ein Nutzer registrieren kann.
                    self.statusofregister = true
                    return
                    
                }
                //Ein Dokument ist vorhanden und status = true für die ShopView und statusofregister = false damit keine RegistrationView angezeigt wird.
                self.statusofregister = false
                self.status = true
            }
        }
            
    }
    
    func SignUp() {
        //Diese Funktion ermöglicht das registieren.
        //Überprüfung, ob Werte eingegeben wurden.
        if email_SignUp == "" || password_SignUp == "" || reEnterPassword == "" {
            self.alertMsg = "Fill Content properly"
            self.alert.toggle()
            return
        }
        //Das Passwort muss zweimal richtig eingegeben werden.
        if password_SignUp != reEnterPassword {
            self.alertMsg = "password missmatch"
            self.alert.toggle()
            return
        }
        //createUser per FirebaseAuth
        Auth.auth().createUser(withEmail: email_SignUp, password: password_SignUp) { (res, err) in
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            //Es wird eine Verifizierungsemail an die verwendete Email gesendet.
            res?.user.sendEmailVerification(completion: { (err) in
                if err != nil {
                    self.alertMsg = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                //Benachrichtigung an den Nutzer per Alert, damit dieser weiß, was er danach tun muss.
                self.alertMsg = "Verify Link has been sent. Verify your email and login after you did it"
                self.alert.toggle()
                
            })
        }
    }
    
    func logOut() {
        //Diese Funktion ermöglicht ein signOut. Alle Werte werden zurückgesetzt
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
