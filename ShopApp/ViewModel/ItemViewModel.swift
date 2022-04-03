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
    
    init(_title: String, _description: String, _price: Double, _sizes: [ShoeSize],_imagePath: String, _rating: Float, _id: String, _discount: Int) {
        title = _title
        description = _description
        price = _price
        sizes = _sizes
        imagePath = _imagePath
        rating = _rating
        id = _id
        discount = _discount
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
    
    func getAllItems() async {
        //In diesem Array werden die Artikel gespeichert
        var newItems = [Item]()
        //do catch Block falls ein Fehler auftritt
        do {
            // Mit async await alle Artikel bekommen
            let data = try await Firestore.firestore().collection("Items").getDocuments()
            //folgender code wird für jeden Artikel ausgeführt
            for document in data.documents {
                // Es wird ein Artikel deklariert. Diese wird später verändert und dem Array aus Zeile 61 hinzugefügt
                var item = Item(_title: "", _description: "", _price: 0.0, _sizes: [], _imagePath: "", _rating: 0.0, _id: "", _discount: 0)
                //Folgender Code sorgt dafür, dass die Daten von Firebase geladen werden.
                item.title = document.data()["title"] as? String ?? "No title"
                item.description = document.data()["description"] as? String ?? "No description"
                item.price = document.data()["price"] as? Double ?? 0.00
                item.imagePath = document.data()["imagePath"] as? String ?? "No path"
                item.rating = document.data()["rating"] as? Float ?? 0.0
                //Die Dokumenten ID wird einmal dem Artikel hinzugefügt und dann für spätere Verwendung in Zeile 81 gespeichert.
                let docId = document.documentID
                item.id = docId
                item.discount = document.data()["discount"] as? Int ?? 0
                //Neuer async await call, damit alle Schuhgrößen des Artikel verfügbar sind
                let shoeSizeDocuments = try await Firestore.firestore().collection("Items").document(docId).collection("Sizes").getDocuments()
                //Nun werden die Daten für jede Größe geholt
                for shoeSize in shoeSizeDocuments.documents {
                    //TODO: Eventuelle anpassung der Zeile im unteren Kommentar
                    //Für die größe wird die Dokument ID genutzt, weil die der größe enspricht. Dies ist deshalb so, damit bei einer späteren Bestellung noch einmal überprüft werden kann, ob der Schuh wirklich in der gewünschten Menge verfügbar ist(Dazu: UserViewModel.swift/createOrder/Zeile217
                    let size = Int(shoeSize.documentID) ?? 0
                    let amount = shoeSize.data()["amount"] as? Int ?? 0
                    item.sizes.append(ShoeSize(_size: size, _amount: amount))
                }
                //Dank async await kann hier der Artikel dem Array hinzugefügt werden. Sonst würde alles "synchronous" ablaufen und der Befehl newItems.append(item) würde schon bevor alle Date vorhanden sind ausgeführt werden.
                newItems.append(item)
            }
            //Nun kann newItems übergeben werden. Dank async await ist dies wieder an dieser Stelle möglich, aus dem selben Grund wie in Zeile 90 beschrieben
            //Normalerweise tritt hier ein Fehler auf, da die Funktion auf einem Backgroundthread läuft und von dort aus nicht die UI geupdatet werden darf. Dank @MainActor am Anfang der Klasse laufen alle Befehle auf dem Mainthread.
            allItems = newItems
        } catch {
            //TODO: Error handling
            print(error)
        }
        
    }
}


