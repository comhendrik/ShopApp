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
    var memberStatus: String
    var email: String
    var memberId: String
    
    init(_firstName: String, _lastName: String, _birthday: Date, _profilePicPath: String, _address: Address, _memberStatus: String, _email: String, _memberId: String) {
        firstName = _firstName
        lastName = _lastName
        birthday = _birthday
        profilePicPath = _profilePicPath
        adress = _address
        memberStatus = _memberStatus
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
    @Published var mainUser = User(_firstName: "???", _lastName: "??", _birthday: Date.now, _profilePicPath: "???", _address: Address(_city: "???", _zipCode: 0, _street: "??", _number: "???", _land: "??"), _memberStatus: "bronze", _email: "???", _memberId: "???")
    @Published var showProgressView = false
    @Published var cartItems: [CartItem] = []
    @Published var favoriteItems: [Item] = []
    @Published var orders: [Order] = []
    @Published var placeholderItem =  Item(_title: "Jordan 1",
                                         _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                         _price: 129.99,
                                         _sizes: [41,42,43,44,45,46,47],
                                         _availableSizes: [41,42,46,47],
                                          _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                         _rating: 2.5,
                                         _id: "00055001",
                              _discount: 45)
    @Published var placeholderCartItem = CartItem(_item: Item(_title: "Jordan 1",
                                                              _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                              _price: 129.99,
                                                              _sizes: [41,42,43,44,45,46,47],
                                                              _availableSizes: [41,42,46,47],
                                                              _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                                              _rating: 2.5,
                                                              _id: "00003401",
                                                              _discount: 0
                                                             ), _size: 45, _amount: 1, _id: "0000340146")
    

    
    func getUser() {
        showProgressView = true
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").getDocument { snap, err in
            self.mainUser = User(_firstName: "???", _lastName: "??", _birthday: Date.now, _profilePicPath: "???", _address: Address(_city: "???", _zipCode: 0, _street: "???", _number: "???", _land: "???"), _memberStatus: "bronze", _email: "???", _memberId: "???")
            if let err = err {
                //TODO: Handle this error properly!
                print(err)
            } else {
                let firstName = snap?.data()?["firstName"] as? String ?? "no firstName"
                let lastName = snap?.data()?["lastName"] as? String ?? "no lastName"
                let birthday = snap?.data()?["birthday"] as? Timestamp
                let profilePicPath = snap?.data()?["profilePic"] as? String ?? "no profile pic"
                let city = snap?.data()?["city"] as? String ?? "no city"
                let zipCode = snap?.data()?["zipcode"] as? Int ?? 0
                let street = snap?.data()?["street"] as? String ?? "no street"
                let number = snap?.data()?["number"] as? String ?? "no number"
                let land = snap?.data()?["land"] as? String ?? "no land"
                let memberStatus = snap?.data()?["memberStatus"] as? String ?? "no member Status"
                let email = snap?.data()?["email"] as? String ?? "no email"
                let memberId = snap?.documentID
                self.mainUser.adress = Address(_city: city, _zipCode: zipCode, _street: street, _number: number, _land: land)
                self.mainUser.firstName = firstName
                self.mainUser.lastName = lastName
                self.mainUser.birthday = birthday?.dateValue() ?? Date.now
                self.mainUser.profilePicPath = profilePicPath
                self.mainUser.memberStatus = memberStatus
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
                    //Nun kann der Artikel der Bestellung hinzugefügt werden.
                    order.items.append(OrderItem(_item: Item(_title: title, _description: description, _price: price, _sizes: sizes, _availableSizes: availableSizes, _imagePath: imagePath, _rating: rating, _id: itemId, _discount: discount), _size: size, _amount: amount, _id: cartItemID, _price: orderedPrice))
                }
                //Dank async await kann hier die Bestellung dem Array hinzugefügt werden. Sonst würde alles "synchronous" ablaufen und dieser Befehl würde schon bevor alle Date vorhanden sind ausgeführt werden.
                newOrders.append(order)
            }
            //Nun kann newOrders übergeben werden. Dank async await ist dies wieder an dieser Stelle möglich
            //Normalerweise tritt hier ein Fehler auf, da die Funktion auf einem Backgroundthread läuft und von dort aus nicht die UI geupdatet werden darf. Dank @MainActor am Anfang der Klasse laufen all Befehle auf dem Mainthread
            orders = newOrders
        } catch {
            print(error)
        }
    }
    
    func createOrders(items: [CartItem], price: Double, deliveryDate: Date) {

        let id = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("Orders").addDocument(data: ["price" : price,
                                    "deliverydate": deliveryDate,
                                    "user": Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid")]).documentID
        
        for cartItem in cartItems {
            var cartItemID = cartItem.id
            _ = cartItemID.removeLast()
            _ = cartItemID.removeLast()
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("Orders").document(id).collection("Items")
                .addDocument(data: ["amount" : cartItem.amount,
                                    "ref":cartItemID,
                                    "size": cartItem.size,
                                    "price": cartItem.item.discount != 0 ? cartItem.item.price - ((cartItem.item.price / 100.0) * Double(cartItem.item.discount)) : cartItem.item.price])
        }
    }
    
    func getFavoriteItems() {
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("Favorites").addSnapshotListener { snap, err in
            if let err = err {
                //TODO: Handle this properly
                print(err)
            } else {
                self.favoriteItems = []
                for doc in snap!.documents {
                    let ref = doc.data()["ref"] as! DocumentReference
                    ref.getDocument { docSnap, err in
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
                            self.favoriteItems.append(Item(_title: title,
                                                                    _description: description,
                                                                    _price: price,
                                                                    _sizes: sizes,
                                                                    _availableSizes: availableSizes,
                                                                    _imagePath: imagePath,
                                                                    _rating: rating,
                                                           _id: id,
                                                                    _discount: discount))
                        }
                    }
                }
            }
        }
    }
    
    func addItemToFavorites(with id: String) {
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("Favorites").document(id).setData(["ref" : itemsRef.document(id)])
        
    }
    
    func deleteFavoriteItem(with id: String) {
        print(id)
        print(Auth.auth().currentUser?.uid ?? "no uid")
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("Favorites").document(id).delete { err in
            if let err = err {
                //TODO: Handle this properly
                print(err)
            } else {
                print("removed")
            }
        }
    }
    
    func getCartItems() {
        showProgressView = true
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("CartItems").addSnapshotListener { cartItemsSnap, err in
            if let err = err {
                //TODO: Handle this properly
                print(err)
                return
            } else {
                self.cartItems = []
                for document in cartItemsSnap!.documents {
                    var newItem = Item(_title: "", _description: "", _price: 0.0, _sizes: [], _availableSizes: [], _imagePath: "", _rating: 0.0, _id: "", _discount: 0)
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
                            newItem.title = title
                            newItem.description = description
                            newItem.price = price
                            newItem.sizes = sizes
                            newItem.availableSizes = availableSizes
                            newItem.imagePath = imagePath
                            newItem.rating = rating
                            newItem.id = item_id
                            newItem.discount = discount
                            self.cartItems.append(CartItem(_item: newItem, _size: size, _amount: amount,_id: id))
                        }
                    }
                    
                    
                }
                
            }
        }
    }
    
    func deleteCartItem(with id: String) {
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
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("CartItems").document(id).updateData(["amount" : amount])
    }
    
    func addItemToCart(with id: String, size: Int, amount: Int) {
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "no uid").collection("CartItems").document(id+String(size)).setData(["size" : size, "itemReference" : id, "amount": amount])
    }
    
    

}
