//
//  ItemViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//
//Dieses ViewModel holt sich die Standard Daten der Items
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Item: Identifiable {
//Der Aufbau eines Item, es muss nur Daten anzeigen können
    var title: String
    var description: String
    var price: Double
    var sizes: [ShoeSize]
    var imagePath: String
    var rating: Float
    var id: String
    var discount: Int
    var temprar: Int
    
    init(_title: String, _description: String, _price: Double, _sizes: [ShoeSize],_imagePath: String, _rating: Float, _id: String, _discount: Int) {
        title = _title
        description = _description
        price = _price
        sizes = _sizes
        imagePath = _imagePath
        rating = _rating
        id = _id
        discount = _discount
        temprar = _discount
    }
    

}

struct ShoeSize: Hashable {
    var size: Int
    var amount: Int
    
    init(_size: Int, _amount: Int) {
        size = _size
        amount = _amount
    }
}

extension ShoeSize: Identifiable {
    var id: Int { size }
}

@MainActor

class ItemViewModel: ObservableObject {
    //Dieses ViewModel lädt alle Items
    @Published var allItems: [Item] = []
    @Published var showProgressView = true
    
    func getAllItems() async {
        //In diesem Array werden die Bestellungen gespeichert
        var newItems = [Item]()
        //do catch Block falls ein Fehler auftritt
        do {
            // Mit async await alle Bestellungen bekommen
            let data = try await Firestore.firestore().collection("Items").getDocuments()
            //folgender code wird für jede Bestellung ausgeführt
            for document in data.documents {
                // Es wird eine Bestellung deklariert. Diese wird später verändert und dem Array von oben hinzugefügt
                var item = Item(_title: "", _description: "", _price: 0.0, _sizes: [], _imagePath: "", _rating: 0.0, _id: "", _discount: 0)
                item.title = document.data()["title"] as? String ?? "No title"
                item.description = document.data()["description"] as? String ?? "No description"
                item.price = document.data()["price"] as? Double ?? 0.00
                item.imagePath = document.data()["imagePath"] as? String ?? "No path"
                item.rating = document.data()["rating"] as? Float ?? 0.0
                let docId = document.documentID
                item.id = docId
                item.discount = document.data()["discount"] as? Int ?? 0
                //Neuer async await call, damit alle Artikel der Bestellung verfügbar sind
                let shoeSizeDocuments = try await Firestore.firestore().collection("Items").document(docId).collection("Sizes").getDocuments()
                //Nun werden sich wieder für jedes Item die Daten geholt
                for shoeSize in shoeSizeDocuments.documents {
                    let size = shoeSize.data()["size"] as? Int ?? 0
                    let amount = shoeSize.data()["amount"] as? Int ?? 0
                    item.sizes.append(ShoeSize(_size: size, _amount: amount))
                }
                //Dank async await kann hier die Bestellung dem Array hinzugefügt werden. Sonst würde alles "synchronous" ablaufen und dieser Befehl würde schon bevor alle Date vorhanden sind ausgeführt werden.
                newItems.append(item)
            }
            //Nun kann newOrders übergeben werden. Dank async await ist dies wieder an dieser Stelle möglich
            //Normalerweise tritt hier ein Fehler auf, da die Funktion auf einem Backgroundthread läuft und von dort aus nicht die UI geupdatet werden darf. Dank @MainActor am Anfang der Klasse laufen all Befehle auf dem Mainthread            allItems = newItems
            allItems = newItems
        } catch {
            print(error)
        }
        
    }
}


