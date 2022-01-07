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
    var birthday: String
    var age: Int
    
    init(_firstName: String, _lastName: String, _birthday: String, _age: Int) {
        firstName = _firstName
        lastName = _lastName
        birthday = _birthday
        age = _age
    }
}

struct Order: Identifiable {
    var price: Double
    var items: [CartItem]
    var deliverydate: Date
    var id: String
}
@MainActor
class UserViewModel: ObservableObject {
    @Published var mainUser = User(_firstName: "???", _lastName: "??", _birthday: "???", _age: 0)
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
    
    
    init() {
        getUser()
        Task {
            //Fetch Orders
            await getData()
        }
        
    }
    
    func getData() async {
        //In diesem Array werden die Bestellungen gespeichert
        var newOrders = [Order]()
        //do catch Block falls ein Fehler auftritt
        do {
            // Mit async await alle Bestellungen bekommen
            let data = try await userRef.collection("Orders").getDocuments()
            //folgender code wird für jede Bestellung ausgeführt
            for document in data.documents {
                // Es wird eine Bestellung deklariert. Diese wird später verändert und dem Array von oben hinzugefügt
                var order = Order(price: 0.0, items: [], deliverydate: Date.now, id: "")
                let price = document.data()["price"] as? Double ?? 0.0
                let deliveryDate = document.data()["deliverydata"] as? Date ?? Date.now
                let orderID = document.documentID
                //Nachdem die Daten von Firestore geladen wurden, wird unsere Bestellung überschrieben
                order.price = price
                order.deliverydate = deliveryDate
                order.id = orderID
                //Neuer async await call, damit alle Artikel der Bestellung verfügbar sind
                let items = try await userRef.collection("Orders").document(orderID).collection("Items").getDocuments()
                //Nun werden sich wieder für jedes Item die Daten geholt
                for item in items.documents {
                    let size = item.data()["size"] as? Int ?? 0
                    let amount = item.data()["amount"] as? Int ?? 0
                    let cartItemID = item.documentID
                    let itemId = item.data()["ref"] as? String ?? "no ref"
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
                    order.items.append(CartItem(_item: Item(_title: title, _description: description, _price: price, _sizes: sizes, _availableSizes: availableSizes, _imagePath: imagePath, _rating: rating, _id: itemId, _discount: discount), _size: size, _amount: amount, _id: cartItemID))
                }
                //Dank async await kann hier die Bestellung dem Array hinzugefügt werden. Sonst würde alles "synchronous" ablaufen und dieser Befehl würde schon bevor alle Date vorhanden sind ausgeführt werden.
                newOrders.append(order)
            }
            //Nun kann newOrders übergeben werden. Dank async await ist dies wieder an dieser Stelle möglich
            //Normalerweise tritt hier ein Fehler auf, da die Funktion auf einem Backgroundthread laufen und von dort aus nicht die UI geupdatet werden darf. Dank @MainActor am Anfang der Klasse laufen all Befehle auf dem Mainthread
            orders = newOrders
        } catch {
            print(error)
        }
    }
    
    func getOrderInfo() {
        for i in 0 ..< orders.count {
            orders[i].items = []
            userRef.collection("Orders").document(orders[i].id).collection("Items").getDocuments { snap, err in
                for item in snap!.documents {
                    let amount = item.data()["amount"] as? Int ?? 0
                    let ref = item.data()["ref"] as? String ?? "No ref"
                    itemsRef.document(ref).getDocument { itemSnap, err in
                        if let err = err {
                            //TODO: Handle this properly
                            print(err)
                        } else {
                            let title = itemSnap!.data()?["title"] as? String ?? "no title"
                            self.orders[i].items.append(CartItem(_item: Item(_title: title, _description: "", _price: 0.0, _sizes: [], _availableSizes: [], _imagePath: "", _rating: 0.0, _id: "", _discount: 0), _size: 0, _amount: amount, _id: ""))
                        }
                    
                    }
                }
            }
        }
    }
    
    func createOrders(items: [CartItem], price: Double) {

        let id = userRef.collection("Orders").addDocument(data: ["price" : price,
                                    "deliverydate": Date.now,
                                    "user": userRef]).documentID
        print(id)
        
        for cartItem in cartItems {
            var cartItemID = cartItem.id
            _ = cartItemID.removeLast()
            _ = cartItemID.removeLast()
            userRef.collection("Orders").document(id).collection("Items")
                .addDocument(data: ["amount" : cartItem.amount,
                                    "ref":cartItemID,
                                    "size": cartItem.size])
        }
    }
    
    
    func getUser() {
        showProgressView = true
        userRef.addSnapshotListener { snap, err in
            self.mainUser = User(_firstName: "???", _lastName: "??", _birthday: "???", _age: 0)
            if let err = err {
                //TODO: Handle this error properly!
                print(err)
            } else {
                let firstName = snap?.data()?["firstName"] as? String ?? "no firstName"
                let lastName = snap?.data()?["lastName"] as? String ?? "no lastName"
                let birthday = snap?.data()?["birthday"] as? String ?? "no birthday"
                let age = snap?.data()?["age"] as? Int ?? 0
                let favoriteItemsReference = snap?.data()?["favoriteItems"] as? [DocumentReference] ?? []
                self.favoriteItems = []
                for reference in favoriteItemsReference {
                    reference.getDocument { docSnap, err in
                        if let err = err {
                            //TODO: Handle this properly!
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
                            let id = docSnap?.documentID ?? "No id"
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
                userRef.collection("CartItems").addSnapshotListener { cartItemsSnap, err in
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
                self.mainUser.firstName = firstName
                self.mainUser.lastName = lastName
                self.mainUser.birthday = birthday
                self.mainUser.age = age
            }
        }
        showProgressView = false
    }
}
