//
//  UserViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 02.01.22.
//
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct User {
    var firstName: String
    var lastName: String
    var birthday: Date
    var profilePicPath: String
    var adress: Address
    var email: String
    var memberId: String
    
    init(_firstName: String, _lastName: String, _birthday: Date, _profilePicPath: String, _address: Address, _email: String, _memberId: String) {
        firstName = _firstName
        lastName = _lastName
        birthday = _birthday
        profilePicPath = _profilePicPath
        adress = _address
        email = _email
        memberId = _memberId
    }
}

struct Address {
    var city: String
    var zipCode: Int
    var street: String
    var number: String
    var land: String
    
    init(_city: String, _zipCode: Int, _street: String, _number: String, _land: String) {
        city = _city
        zipCode = _zipCode
        street = _street
        number = _number
        land = _land
    }
}

struct Order: Identifiable {
    var price: Double
    var items: [OrderItem]
    var deliverydate: Date
    var id: String
}
struct OrderItem: Identifiable {
    var item: Item
    var size: Int
    var id: String
    var amount: Int
    var price: Double
    
    init(_item: Item, _size: Int, _amount: Int, _id: String, _price: Double) {
        item = _item
        size = _size
        id = _id
        amount = _amount
        price = _price
    }
}

struct CartItem: Identifiable {
    var item: Item
    var size: Int
    var id: String
    var amount: Int
    
    init(_item: Item, _size: Int, _amount: Int, _id: String) {
        item = _item
        size = _size
        id = _id
        amount = _amount
    }
}


@MainActor
class UserViewModel: ObservableObject {
    //Dieses Viewmodel enthält alle Information für den Nutzer
    @Published var mainUser = User(_firstName: "???", _lastName: "??", _birthday: Date.now, _profilePicPath: "???", _address: Address(_city: "???", _zipCode: 0, _street: "??", _number: "???", _land: "??"),_email: "???", _memberId: "???")
    @Published var showProgressView = false
    @Published var cartItems: [CartItem] = []
    @Published var favoriteItems: [Item] = []
    @Published var orders: [Order] = []
    //Das folgende Objekt wird verwendet, damit man bei der Favorites View ein neues Item zum Warenkorb hinzufügen kann. Es wird in der AddToCartView verwendet.
    @Published var placeholderItem =  Item(_title: "jordan 1",
                                           _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                           _price: 129.99,
                                           _sizes: [41,42,43,44,45,46,47],
                                           _availableSizes: [41,42,46,47],
                                           _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                           _rating: 2.5,
                                           _id: "00003401",
                                                                                             _discount: 0, _inStock: 5
                           )
    @Published var alertMessage = ""
    @Published var showAlert = false
    let userID = Auth.auth().currentUser?.uid ?? "no uid"
    

    
    func getUser() {
        showProgressView = true
        //Es wird per .getDocument das Dokument, welches zur uid des angemeldeten Nutzers gehört.
        Firestore.firestore().collection("Users").document(userID).getDocument { snap, err in
            self.mainUser = User(_firstName: "???", _lastName: "??", _birthday: Date.now, _profilePicPath: "???", _address: Address(_city: "???", _zipCode: 0, _street: "???", _number: "???", _land: "???"), _email: "???", _memberId: "???")
            if let err = err {
                //TODO: Handle this error properly!
                self.showProgressView = false
                print(err)
                return
            } else {
                //Daten werden innerhalb von MainUser gespeichert
                let firstName = snap?.data()?["firstName"] as? String ?? "no firstName"
                let lastName = snap?.data()?["lastName"] as? String ?? "no lastName"
                let birthday = snap?.data()?["birthday"] as? Timestamp
                let profilePicPath = snap?.data()?["profilePic"] as? String ?? "no profile pic"
                let city = snap?.data()?["city"] as? String ?? "no city"
                let zipCode = snap?.data()?["zipcode"] as? Int ?? 0
                let street = snap?.data()?["street"] as? String ?? "no street"
                let number = snap?.data()?["number"] as? String ?? "no number"
                let land = snap?.data()?["land"] as? String ?? "no land"
                let email = snap?.data()?["email"] as? String ?? "no email"
                let memberId = snap?.documentID
                self.mainUser.adress = Address(_city: city, _zipCode: zipCode, _street: street, _number: number, _land: land)
                self.mainUser.firstName = firstName
                self.mainUser.lastName = lastName
                self.mainUser.birthday = birthday?.dateValue() ?? Date.now
                self.mainUser.profilePicPath = profilePicPath
                self.mainUser.email = email
                self.mainUser.memberId = memberId ?? "no id"
            }
        }
        showProgressView = false
    }
    
    func getOrders() async {
        //In diesem Array werden die Bestellungen gespeichert
        var newOrders = [Order]()
        //do catch Block falls ein Fehler auftritt
        do {
            // Mit async await alle Bestellungen bekommen
            let data = try await Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("Orders").getDocuments()
            //folgender code wird für jede Bestellung ausgeführt
            for document in data.documents {
                // Es wird eine Bestellung deklariert. Diese wird später verändert und dem Array von oben hinzugefügt
                var order = Order(price: 0.0, items: [], deliverydate: Date.now, id: "")
                let price = document.data()["price"] as? Double ?? 0.0
                let deliveryDate = document.data()["deliverydata"] as? Timestamp ?? Timestamp(date: Date.now)
                let orderID = document.documentID
                //Nachdem die Daten von Firestore geladen wurden, wird unsere Bestellung überschrieben
                order.price = price
                order.deliverydate = deliveryDate.dateValue()
                order.id = orderID
                //Neuer async await call, damit alle Artikel der Bestellung verfügbar sind
                let items = try await Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("Orders").document(orderID).collection("Items").getDocuments()
                //Nun werden sich wieder für jedes Item die Daten geholt
                for item in items.documents {
                    let size = item.data()["size"] as? Int ?? 0
                    let amount = item.data()["amount"] as? Int ?? 0
                    let cartItemID = item.documentID
                    let itemId = item.data()["ref"] as? String ?? "no ref"
                    let orderedPrice = item.data()["price"] as? Double ?? 0.0
                    //Nächster async await call, da nur die artikel id in einer Bestellung gespeichert wird
                    let itemData = try await itemsRef.document(itemId).getDocument()
                    let title = itemData.data()?["title"] as? String ?? "No title"
                    let description = itemData.data()?["description"] as? String ?? "No description"
                    let price = itemData.data()?["price"] as? Double ?? 0.00
                    let sizes = itemData.data()?["sizes"] as? [Int] ?? []
                    let availableSizes = itemData.data()?["availableSizes"] as? [Int] ?? []
                    let imagePath = itemData.data()?["imagePath"] as? String ?? "No path"
                    let rating = itemData.data()?["rating"] as? Float ?? 0.0
                    let discount = itemData.data()?["discount"] as? Int ?? 0
                    let inStock = itemData.data()?["inStock"] as? Int ?? 0
                    //Nun kann der Artikel der Bestellung hinzugefügt werden.
                    order.items.append(OrderItem(_item: Item(_title: title, _description: description, _price: price, _sizes: sizes, _availableSizes: availableSizes, _imagePath: imagePath, _rating: rating, _id: itemId, _discount: discount, _inStock: inStock), _size: size, _amount: amount, _id: cartItemID, _price: orderedPrice))
                }
                //Dank async await kann hier die Bestellung dem Array hinzugefügt werden. Sonst würde alles "synchronous" ablaufen und dieser Befehl würde schon bevor alle Date vorhanden sind ausgeführt werden.
                newOrders.append(order)
            }
            //Nun kann newOrders übergeben werden. Dank async await ist dies wieder an dieser Stelle möglich
            //Normalerweise tritt hier ein Fehler auf, da die Funktion auf einem Backgroundthread läuft und von dort aus nicht die UI geupdatet werden darf. Dank @MainActor am Anfang der Klasse laufen all Befehle auf dem Mainthread
            orders = newOrders
            //TODO: nicht richtig sortiert. Die neuesten sollten ganz oben stehen.
        } catch {
            print(error)
        }
    }
    
    func createOrders(price: Double, deliveryDate: Date) async {
        if cartItems.isEmpty {
            //Überprüfung, ob ein Item vorhanden ist findet statt.
            alertMessage = "Thank you for wanting to order, but please add some items."
            showAlert.toggle()
        } else {
            //überprüfen, ob ein Item nicht auf Lager ist.
            do {
                for cartItem in cartItems {
                    //data ist ein dictionary mit allen Werten von Firebase. Es wird überprüft, ob sich seid dem Hinzufügen etwas am Bestand geändert hat.
                    //TODO: Mehrere inStock Werte für die verschiedenen Größen
                    let data = try await itemsRef.document(cartItem.item.id).getDocument().data()
                    if data?["inStock"] as? Int ?? 0 < cartItem.amount {
                        alertMessage = "The item \(cartItem.item.title) is not available. Try to reload or adjust the amount."
                        showAlert.toggle()
                        return
                    }
                }
            } catch {
                print(error)
                alertMessage = error.localizedDescription
                showAlert.toggle()
                return
            }
            //Wird dieser Code ausgeführt können alle Produkte gekauft werden.
            //Dem User wird eine Order hinzugefügt
            let id = Firestore.firestore().collection("Users").document(mainUser.memberId).collection("Orders").addDocument(data: ["price" : price,
                                        "deliverydate": deliveryDate,
                                        "user": Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid")]).documentID
            //Der Order werden die Produkte hinzugefügt
            for cartItem in cartItems {
                do {Firestore.firestore().collection("Users").document(mainUser.memberId).collection("Orders").document(id).collection("Items")
                        .addDocument(data: ["amount" : cartItem.amount,
                                            "ref":cartItem.item.id,
                                            "size": cartItem.size,
                                            "price": cartItem.item.discount != 0 ? cartItem.item.price - ((cartItem.item.price / 100.0) * Double(cartItem.item.discount)) : cartItem.item.price])
                    //Update Items auf Lager
                    try await itemsRef.document(cartItem.item.id).updateData(["inStock" : cartItem.item.inStock-1])
                    //Lösche das Produkt aus dem Warenkorb
                    deleteCartItem(with: cartItem.id)
                } catch {
                    print(error)
                    alertMessage = error.localizedDescription
                    showAlert.toggle()
                    return
                }
            }
            //Die Bestellung ist erfolgreich durchgeführt worden.
            alertMessage = "Thank you for ordering. We do our best to send the order to you as fast as possible! \n OrderID: \(id)"
            showAlert.toggle()
            //Neue Bestellung in die App laden.
            await getOrders()
            
            
        }
        
        
    }
    
    func getFavoriteItems() {
        //Die favorisierten Items werden per Snapshotlistener abgerufen, damit bei Änderung direkt die UI geändert wird, ohne dass noch mehr zu programmieren ist.
        Firestore.firestore().collection("Users").document(userID).collection("Favorites").addSnapshotListener { snap, err in
            if let err = err {
                //TODO: Handle this properly
                print(err)
            } else {
                //Wichtig ist es self.favoriteItems = [] zu setzen, da sonst doppelte Items auftreten können.
                self.favoriteItems = []
                for doc in snap!.documents {
                    //Die Items sind in einer collection innerhalb des User Dokuments gespeichert. Das einzelne Dokument enthält eine Referenz zum Item, damit keine doppelte Speicherung in der Datenbank stattfindet.
                    let ref = doc.data()["ref"] as! DocumentReference
                    ref.getDocument { docSnap, err in
                        //Wurde eine Referenz gefunden, wird das originale Item abgerufen mit .getDocument.
                        if let err = err {
                            //TODO: Handle this properly
                            print(err)
                        } else {
                            let document = docSnap?.data()
                            let title = document?["title"] as? String ?? "No title"
                            let description = document?["description"] as? String ?? "No description"
                            let price = document?["price"] as? Double ?? 0.00
                            let sizes = document?["sizes"] as? [Int] ?? []
                            let availableSizes = document?["availableSizes"] as? [Int] ?? []
                            let imagePath = document?["imagePath"] as? String ?? "No path"
                            let rating = document?["rating"] as? Float ?? 0.0
                            let id = docSnap?.documentID ?? "no id"
                            let discount = document?["discount"] as? Int ?? 0
                            let inStock = document?["inStock"] as? Int ?? 0
                            self.favoriteItems.append(Item(_title: title,
                                                            _description: description,
                                                            _price: price,
                                                            _sizes: sizes,
                                                            _availableSizes: availableSizes,
                                                            _imagePath: imagePath,
                                                            _rating: rating,
                                                           _id: id,
                                                           _discount: discount,
                                                          _inStock: inStock))
                        }
                    }
                }
            }
        }
    }
    
    func addItemToFavorites(with id: String) {
        //Diese Funktion fügt einen neune Favoriten hinzu, indem nur die Referenz des Items gespeichert. Der Button in ItemDetail mit der Beschreibung Add to Favorites führt diese Aktion aus.
        Firestore.firestore().collection("Users").document(userID).collection("Favorites").document(id).setData(["ref" : itemsRef.document(id)])
        
    }
    
    func deleteFavoriteItem(with id: String) {
        //Diese Funktion löscht eine favorisiertes Item, indem es per ID eines Items in der collection "Favorites" eines Nutzers gefunden wird.
        Firestore.firestore().collection("Users").document(userID).collection("Favorites").document(id).delete { err in
            if let err = err {
                //TODO: Handle this properly
                print(err)
            } else {
                print("removed")
            }
        }
    }
    
    func checkIfItemIsAlreadyFavorite(with id: String) -> Bool {
        //Diese Funktion wird verwendet, um zu überprüfen, ob ein Item bereits verfügbar ist. Dies ermöglicht eine Animation des Add To Favorites Button in ItemDetail, sowie die gewünschte Ausführung, von einer der beiden oberhalb definierten Funktionen(addItemToFavorites, deleteFavoriteItem)
        for item in favoriteItems {
            if item.id == id {
                return true
            }
        }
        return false
    }
    
    func getCartItems() {
        showProgressView = true
        //Durch diese Funktion werden alle Warenkorb Items abgefragt. Diese befinden sich in der "CartItems" Collection eines User Dokuments. Auch hier wird ein snapshotlistener verwendet, damit Echtzeitabfragen stattfinden können.
        Firestore.firestore().collection("Users").document(userID).collection("CartItems").addSnapshotListener { cartItemsSnap, err in
            if let err = err {
                //TODO: Handle this properly
                print(err)
                return
            } else {
                self.cartItems = []
                //Wichtig ist es self.cartItems = [] zu setzen, da sonst doppelte Items auftreten können.
                for document in cartItemsSnap!.documents {
                    //Zuerst werden die im Warenkorb spezifisch definierten Attribute abgerufen. Dann wird das dazugehörige Item abgefragt.
                    let itemReference = document.data()["itemReference"] as? String ?? "No id"
                    let size = document.data()["size"] as? Int ?? 0
                    let amount = document.data()["amount"] as? Int ?? 0
                    let id = document.documentID
                    itemsRef.document(itemReference).getDocument { docSnap, err in
                        if let err = err {
                            //TODO: Handle properly
                            print(err)
                            return
                        } else {
                            let document = docSnap?.data()
                            let title = document?["title"] as? String ?? "No title"
                            let description = document?["description"] as? String ?? "No description"
                            let price = document?["price"] as? Double ?? 0.00
                            let sizes = document?["sizes"] as? [Int] ?? []
                            let availableSizes = document?["availableSizes"] as? [Int] ?? []
                            let imagePath = document?["imagePath"] as? String ?? "No path"
                            let rating = document?["rating"] as? Float ?? 0.0
                            let item_id = docSnap?.documentID ?? "no id"
                            let discount = document?["discount"] as? Int ?? 0
                            let inStock = document?["inStock"] as? Int ?? 0
                            self.cartItems.append(CartItem(_item: Item(_title: title, _description: description, _price: price, _sizes: sizes, _availableSizes: availableSizes, _imagePath: imagePath, _rating: rating, _id: item_id, _discount: discount, _inStock: inStock), _size: size, _amount: amount,_id: id))
                        }
                    }
                    
                    
                }
                
            }
        }
    }
    
    func deleteCartItem(with id: String) {
        //Löschen eines Items im Warenkorb. Es wird die ID eines CartItems benötigt
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("CartItems").document(id).delete { err in
            if let err = err {
                //TODO: Handle this properly
                print(err)
            } else {
                print("removed")
            }
        }
    }
    
    func updateAmount(with id: String, amount: Int) {
        //Anzahl wird erhöht und. Als Id wird die ID eines CartItems benötigt.
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("CartItems").document(id).updateData(["amount" : amount])
    }
    
    func addItemToCart(with id: String, size: Int, amount: Int) -> Bool {
        if size == 0 {
            //Es wird übeprüft, ob eine größe ausgewählt wurde, wenn size == 0 ist wurde keine ausgewählt
            alertMessage = "Please select a size"
            showAlert.toggle()
            return false
            //Es wird false zurückgegeben, damit keine Animation in der View getriggert wird.
        }
        //Zuerst wird überprüft, ob sich der Artikel bereits im Warenkorb befindet.
        //Wir verwenden id+String(size) als Indikator, da wir so einzelne Größen eines Artikels speichern können. Hat der Artikel die Nummer 1HKLK0KJP wird der Artikel in der Größe 45 als 1HKLK0KJP45 gespeichert.
        let docRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("CartItems").document(id+String(size))
        docRef.getDocument { (document, error) in
            if document!.exists {
                //Ist der Artikel vorhanden holen wir uns die Anzahl des Artikels, die im Warenkorb gespeichert wurde und erhöhen diese.
                let oldAmount = document!.data()?["amount"] as? Int ?? 0
                self.updateAmount(with: id+String(size), amount: oldAmount + amount)
              } else {
                  //Der Artikel ist nicht vorhanden und wird neu erstellt mit Größe, neuer Id, Anzahl = 1 und einem String der auf das richtige Item hinweist.
                  Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("CartItems").document(id+String(size)).setData(["size" : size, "itemReference" : id, "amount": amount])
              }
        }
        return true
        
    }
    
    


}
