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
    var sizes: [Int]
    //amountOfSizes[0] zeigt die Anzahl der Größe an Stelle sizes[0]
    var amountOfSizes: [Int]
    var imagePath: String
    var rating: Float
    var id: String
    var discount: Int
    var temprar: Int
    
    init(_title: String, _description: String, _price: Double, _sizes: [Int], _amountOfSizes: [Int],_imagePath: String, _rating: Float, _id: String, _discount: Int) {
        title = _title
        description = _description
        price = _price
        sizes = _sizes
        amountOfSizes = _amountOfSizes
        imagePath = _imagePath
        rating = _rating
        id = _id
        discount = _discount
        temprar = _discount
    }
    

}


class ItemViewModel: ObservableObject {
    //Dieses ViewModel lädt alle Items
    @Published var allItems: [Item] = []
    @Published var showProgressView = true
    //Beim initaliesieren werden alle Produkte geladen
    init() {
        getAllItems()
    }
    
    
    func getAllItems() {
        //Diese Funktion lädt alle Schuhe
        showProgressView = true
        //Erstmal wird eine ProgressView angezeigt
        itemsRef.getDocuments { snap, err in
            //Es wird getDocuments verwendet, um die Daten von Firebase zu erhalten.
            //Ein snapshotlistener ist nicht von Nöten, da Echtzeitupdates ist diesem Bereich nicht notwendig ist.
            if let err = err {
                //Tritt ein Fehler wird dieser geprintet und eine ProgressView wird nicht mehr angezeigt
                //TODO: Handle error properly
                print(err)
                self.showProgressView = false
                return
            } else {
                //Wurden Dokumente gefunden wird folgender Code ausgeführt:
                for document in snap!.documents {
                    //Zuerst werden alle Attribute geholt und dann wird der Schuh den shoes array hinzugefügt
                    let title = document.data()["title"] as? String ?? "No title"
                    let description = document.data()["description"] as? String ?? "No description"
                    let price = document.data()["price"] as? Double ?? 0.00
                    let sizes = document.data()["sizes"] as? [Int] ?? []
                    let amountOfSizes = document.data()["amountOfSizes"] as? [Int] ?? []
                    let imagePath = document.data()["imagePath"] as? String ?? "No path"
                    let rating = document.data()["rating"] as? Float ?? 0.0
                    let id = document.documentID
                    let discount = document.data()["discount"] as? Int ?? 0
                    self.allItems.append(Item(_title: title,
                                           _description: description,
                                           _price: price,
                                           _sizes: sizes,
                                           _amountOfSizes: amountOfSizes,
                                           _imagePath: imagePath,
                                           _rating: rating,
                                           _id: id,
                                           _discount: discount))
                }
            }
        }
        //Die Schuhe sind nun im shoes Array, also wird die ProgressView nicht mehr angezeigt.
        showProgressView = false
    }
}


