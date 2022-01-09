//
//  ItemViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Item: Identifiable {
    
    var title: String
    var description: String
    var price: Double
    var sizes: [Int]
    var availableSizes: [Int]
    var imagePath: String
    var rating: Float
    var id: String
    var discount: Int
    
    init(_title: String, _description: String, _price: Double, _sizes: [Int], _availableSizes: [Int], _imagePath: String, _rating: Float, _id: String, _discount: Int) {
        title = _title
        description = _description
        price = _price
        sizes = _sizes
        availableSizes = _availableSizes
        imagePath = _imagePath
        rating = _rating
        id = _id
        discount = _discount
    }
    

}

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var cartItems: [CartItem] = []
    @Published var favoriteItems: [Item] = []
    @Published var showProgressView = true
    @Published var placeholderCartItem = CartItem(_item: Item(_title: "Jordan 1",
                                                              _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                              _price: 129.99,
                                                              _sizes: [41,42,43,44,45,46,47],
                                                              _availableSizes: [41,42,46,47],
                                                              _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                                              _rating: 2.5,
                                                              _id: "00003401",
                                                              _discount: 0
                                                             ), _size: 45, _amount: 1, _id: "asdf")
    @Published var placeholderItem =  Item(_title: "Jordan 1",
                                         _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                         _price: 129.99,
                                         _sizes: [41,42,43,44,45,46,47],
                                         _availableSizes: [41,42,46,47],
                                          _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                         _rating: 2.5,
                                         _id: "00055001",
                              _discount: 45)
    //TODO: stuff with firebase
    init() {
        self.getItems()
    }
    

    
    func getItems() {
        showProgressView = true
        itemsRef.getDocuments { snap, err in
            if let err = err {
                //TODO: Handle error properly
                print(err)
                self.showProgressView = false
                return
            } else {
                for document in snap!.documents {
                    let title = document.data()["title"] as? String ?? "No title"
                    let description = document.data()["description"] as? String ?? "No description"
                    let price = document.data()["price"] as? Double ?? 0.00
                    let sizes = document.data()["sizes"] as? [Int] ?? []
                    let availableSizes = document.data()["availableSizes"] as? [Int] ?? []
                    let imagePath = document.data()["imagePath"] as? String ?? "No path"
                    let rating = document.data()["rating"] as? Float ?? 0.0
                    let id = document.documentID
                    let discount = document.data()["discount"] as? Int ?? 0
                    self.items.append(Item(_title: title,
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
        showProgressView = false
    }
}
