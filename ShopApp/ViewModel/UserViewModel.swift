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
    var adress: Address
    var email: String
    var memberId: String
    
    init(_firstName: String, _lastName: String, _address: Address, _email: String, _memberId: String) {
        firstName = _firstName
        lastName = _lastName
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
    var orderDate: Date
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
    @Published var mainUser = User(_firstName: "Loading...", _lastName: "Loading...", _address: Address(_city: "???", _zipCode: 0, _street: "Loading...", _number: "Loading...", _land: "Loading..."),_email: "Loading...", _memberId: "Loading...")
    @Published var showProgressView = false
    @Published var cartItems: [CartItem] = []
    @Published var favoriteItems: [Item] = []
    @Published var orders: [Order] = []
    //Das folgende Objekt wird verwendet, damit man bei der Favorites View ein neues Item zum Warenkorb hinzufügen kann. Es wird in der AddToCartView verwendet.
    @Published var placeholderItem =  Item(_title: "jordan 1",
                                           _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                           _price: 129.99,
                                           _sizes: [ShoeSize(_size: 45, _amount: 5), ShoeSize(_size: 46, _amount: 0), ShoeSize(_size: 47, _amount: 5), ShoeSize(_size: 48, _amount: 0)],
                                           _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                           _rating: 2.5,
                                           _id: "00003401",
                                           _discount: 0)
    @Published var alertMessage = ""
    @Published var showAlert = false
    let userID = Auth.auth().currentUser?.uid ?? "no uid"
    

    
    func getUser() {
        showProgressView = true
        //Es wird per .getDocument das Dokument, welches zur uid des angemeldeten Nutzers gehört.
        Firestore.firestore().collection("Users").document(userID).getDocument { snap, err in
            self.mainUser = User(_firstName: "???", _lastName: "??", _address: Address(_city: "???", _zipCode: 0, _street: "???", _number: "???", _land: "???"), _email: "???", _memberId: "???")
            if let err = err {
                //TODO: Handle this error properly!
                self.showProgressView = false
                print(err)
                return
            } else {
                //Daten werden innerhalb von MainUser gespeichert
                let firstName = snap?.data()?["firstName"] as? String ?? "no firstName"
                let lastName = snap?.data()?["lastName"] as? String ?? "no lastName"
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
                var order = Order(price: 0.0, items: [], orderDate: Date.now, id: "")
                let price = document.data()["price"] as? Double ?? 0.0
                let orderDate = document.data()["orderDate"] as? Timestamp ?? Timestamp(date: Date.now)
                let orderID = document.documentID
                //Nachdem die Daten von Firestore geladen wurden, wird unsere Bestellung überschrieben
                order.price = price
                order.orderDate = orderDate.dateValue()
                order.id = orderID
                //Neuer async await call, damit alle Artikel der Bestellung verfügbar sind
                let items = try await Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("Orders").document(orderID).collection("Items").getDocuments()
                //Nun werden sich wieder für jedes Item die Daten geholt
                
                for itemOfOder in items.documents {
                    let size = itemOfOder.data()["size"] as? Int ?? 0
                    let amount = itemOfOder.data()["amount"] as? Int ?? 0
                    let cartItemID = itemOfOder.documentID
                    let itemId = itemOfOder.data()["ref"] as? String ?? "no ref"
                    let orderedPrice = itemOfOder.data()["price"] as? Double ?? 0.0
                    //Nächster async await call, da nur die artikel id in einer Bestellung gespeichert wird
                    let itemData = try await itemsRef.document(itemId).getDocument()
                    var item = Item(_title: "", _description: "", _price: 0.0, _sizes: [], _imagePath: "", _rating: 0.0, _id: "", _discount: 0)
                    item.title = itemData.data()?["title"] as? String ?? "No title"
                    item.description = itemData.data()?["description"] as? String ?? "No description"
                    item.price = itemData.data()?["price"] as? Double ?? 0.00
                    item.imagePath = itemData.data()?["imagePath"] as? String ?? "No path"
                    item.rating = itemData.data()?["rating"] as? Float ?? 0.0
                    let docId = itemData.documentID
                    item.id = docId
                    item.discount = itemData.data()?["discount"] as? Int ?? 0
                    //Neuer async await call, damit alle Artikel der Bestellung verfügbar sind
                    let shoeSizeDocuments = try await Firestore.firestore().collection("Items").document(docId).collection("Sizes").getDocuments()
                    //Nun werden sich wieder für jedes Item die Daten geholt
                    //Nun müssen müssen noch Schuhgrößen gefetcht werden.
                    for shoeSize in shoeSizeDocuments.documents {
                        let size = shoeSize.data()["size"] as? Int ?? 0
                        let amount = shoeSize.data()["amount"] as? Int ?? 0
                        item.sizes.append(ShoeSize(_size: size, _amount: amount))
                    }
                    //Nun kann der Artikel der Bestellung hinzugefügt werden.
                    order.items.append(OrderItem(_item: item, _size: size, _amount: amount, _id: cartItemID, _price: orderedPrice))
                }
                //Dank async await kann hier die Bestellung dem Array hinzugefügt werden. Sonst würde alles "synchronous" ablaufen und dieser Befehl würde schon bevor alle Date vorhanden sind ausgeführt werden.
                newOrders.append(order)
            }
            //Nun kann newOrders übergeben werden. Dank async await ist dies wieder an dieser Stelle möglich
            //Normalerweise tritt hier ein Fehler auf, da die Funktion auf einem Backgroundthread läuft und von dort aus nicht die UI geupdatet werden darf. Dank @MainActor am Anfang der Klasse laufen all Befehle auf dem Mainthread
            //Zusätzlich werden die Bestellungen nach Datum sortiert, so dass die neuesten oben stehen.
            orders = newOrders.sorted(by: { $0.orderDate > $1.orderDate })
            
        } catch {
            print(error)
        }
    }
    
    func createOrder(price: Double) async {
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
                                                                                                                                   "orderDate": Date.now.addingTimeInterval(TimeInterval(89000)),
                                                                                                                                   "user": Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid")]).documentID
            //Der Order werden die Produkte hinzugefügt
            for cartItem in cartItems {
                do {
                    Firestore.firestore().collection("Users").document(mainUser.memberId).collection("Orders").document(id).collection("Items")
                        .addDocument(data: ["amount" : cartItem.amount,
                                            "ref":cartItem.item.id,
                                            "size": cartItem.size,
                                            "price": cartItem.item.discount != 0 ? cartItem.item.price - ((cartItem.item.price / 100.0) * Double(cartItem.item.discount)) : cartItem.item.price])
                    //TODO: Update Items auf Lager
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
    
    func getFavoriteItems() async {
        //In diesem Array werden die Bestellungen gespeichert
        var newFavoriteItems = [Item]()
        //do catch Block falls ein Fehler auftritt
        do {
            // Mit async await alle Bestellungen bekommen
            let items = try await Firestore.firestore().collection("Users").document(userID).collection("Favorites").getDocuments()
            //folgender code wird für jede Bestellung ausgeführt
            for favoriteItem in items.documents {
                // Es wird eine Bestellung deklariert. Diese wird später verändert und dem Array von oben hinzugefügt
                let ref = favoriteItem.data()["ref"] as! DocumentReference
                var item = Item(_title: "", _description: "", _price: 0.0, _sizes: [], _imagePath: "", _rating: 0.0, _id: "", _discount: 0)
                let document  = try await ref.getDocument()
                item.title = document.data()?["title"] as? String ?? "No title"
                item.description = document.data()?["description"] as? String ?? "No description"
                item.price = document.data()?["price"] as? Double ?? 0.00
                item.imagePath = document.data()?["imagePath"] as? String ?? "No path"
                item.rating = document.data()?["rating"] as? Float ?? 0.0
                let docId = document.documentID
                item.id = docId
                item.discount = document.data()?["discount"] as? Int ?? 0
                //Neuer async await call, damit alle Artikel der Bestellung verfügbar sind
                let shoeSizeDocuments = try await Firestore.firestore().collection("Items").document(docId).collection("Sizes").getDocuments()
                //Nun werden sich wieder für jedes Item die Daten geholt
                for shoeSize in shoeSizeDocuments.documents {
                    let size = shoeSize.data()["size"] as? Int ?? 0
                    let amount = shoeSize.data()["amount"] as? Int ?? 0
                    item.sizes.append(ShoeSize(_size: size, _amount: amount))
                }
                //Dank async await kann hier die Bestellung dem Array hinzugefügt werden. Sonst würde alles "synchronous" ablaufen und dieser Befehl würde schon bevor alle Date vorhanden sind ausgeführt werden.
                newFavoriteItems.append(item)
            }
            //Nun kann newOrders übergeben werden. Dank async await ist dies wieder an dieser Stelle möglich
            //Normalerweise tritt hier ein Fehler auf, da die Funktion auf einem Backgroundthread läuft und von dort aus nicht die UI geupdatet werden darf. Dank @MainActor am Anfang der Klasse laufen all Befehle auf dem Mainthread            allItems = newItems
            favoriteItems = newFavoriteItems
        } catch {
            print(error)
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
    
    func getCartItems() async {
        //In diesem Array werden die Bestellungen gespeichert
        var newCartItems = [CartItem]()
        //do catch Block falls ein Fehler auftritt
        do {
            // Mit async await alle Bestellungen bekommen
            let data = try await Firestore.firestore().collection("Users").document(userID).collection("CartItems").getDocuments()
            //folgender code wird für jede Bestellung ausgeführt
            for document in data.documents {
                var cartItem = CartItem(_item: Item(_title: "", _description: "", _price: 0.0, _sizes: [], _imagePath: "", _rating: 0.0, _id: "", _discount: 0), _size: 0, _amount: 0, _id: "")
                let itemReference = document.data()["itemReference"] as? String ?? "No id"
                cartItem.size = document.data()["size"] as? Int ?? 0
                cartItem.amount = document.data()["amount"] as? Int ?? 0
                cartItem.id = document.documentID
                
                let itemRef = try await Firestore.firestore().collection("Items").document(itemReference).getDocument()
                cartItem.item.title = itemRef.data()?["title"] as? String ?? "No title"
                cartItem.item.description = itemRef.data()?["description"] as? String ?? "No description"
                cartItem.item.price = itemRef.data()?["price"] as? Double ?? 0.00
                cartItem.item.imagePath = itemRef.data()?["imagePath"] as? String ?? "No path"
                cartItem.item.rating = itemRef.data()?["rating"] as? Float ?? 0.0
                let docId = itemRef.documentID
                cartItem.item.id = docId
                cartItem.item.discount = itemRef.data()?["discount"] as? Int ?? 0
                //Neuer async await call, damit alle Artikel der Bestellung verfügbar sind
                let shoeSizeDocuments = try await Firestore.firestore().collection("Items").document(docId).collection("Sizes").getDocuments()
                //Nun werden sich wieder für jedes Item die Daten geholt
                for shoeSize in shoeSizeDocuments.documents {
                    let size = shoeSize.data()["size"] as? Int ?? 0
                    let amount = shoeSize.data()["amount"] as? Int ?? 0
                    cartItem.item.sizes.append(ShoeSize(_size: size, _amount: amount))
                }
                //Dank async await kann hier die Bestellung dem Array hinzugefügt werden. Sonst würde alles "synchronous" ablaufen und dieser Befehl würde schon bevor alle Date vorhanden sind ausgeführt werden.
                newCartItems.append(cartItem)
            }
            //Nun kann newOrders übergeben werden. Dank async await ist dies wieder an dieser Stelle möglich
            //Normalerweise tritt hier ein Fehler auf, da die Funktion auf einem Backgroundthread läuft und von dort aus nicht die UI geupdatet werden darf. Dank @MainActor am Anfang der Klasse laufen all Befehle auf dem Mainthread            allItems = newItems
            cartItems = newCartItems
        } catch {
            print(error)
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
