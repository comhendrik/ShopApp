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
    var cartItems: [CartItem]
    var favoriteItems: [Item]
    
    init(_firstName: String, _lastName: String, _birthday: String, _age: Int, _cartItems: [CartItem], _favoriteItems: [Item]) {
        firstName = _firstName
        lastName = _lastName
        birthday = _birthday
        age = _age
        cartItems = _cartItems
        favoriteItems = _favoriteItems
    }
}

class UserViewModel: ObservableObject {
    @Published var mainUser = User(_firstName: "???", _lastName: "??", _birthday: "???", _age: 0, _cartItems: [], _favoriteItems: [])
    @Published var showProgressView = false
    let itemsRef = Firestore.firestore().collection("Items")
    let userRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "M1c92mRQiKdPtaNKj8tT")
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
                                              ), _size: 45)
    
    
    init() {
        getUser()
    }
    
    
    func getUser() {
        showProgressView = true
        userRef.addSnapshotListener { snap, err in
            self.mainUser = User(_firstName: "???", _lastName: "??", _birthday: "???", _age: 0, _cartItems: [], _favoriteItems: [])
            if let err = err {
                //TODO: Handle this error properly!
                print(err)
            } else {
                let firstName = snap?.data()?["firstName"] as? String ?? "no firstName"
                let lastName = snap?.data()?["lastName"] as? String ?? "no lastName"
                let birthday = snap?.data()?["birthday"] as? String ?? "no birthday"
                let age = snap?.data()?["age"] as? Int ?? 0
                let favoriteItemsReference = snap?.data()?["favoriteItems"] as? [DocumentReference] ?? []
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
                            let id = document?["id"] as? String ?? "No id"
                            let discount = document?["discount"] as? Int ?? 0
                            self.mainUser.favoriteItems.append(Item(_title: title,
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
                self.userRef.collection("CartItems").addSnapshotListener { cartItemsSnap, err in
                    if let err = err {
                        //TODO: Handle this properly
                        print(err)
                        return
                    } else {
                        self.mainUser.cartItems = []
                        for document in cartItemsSnap!.documents {
                            var newItem = Item(_title: "", _description: "", _price: 0.0, _sizes: [], _availableSizes: [], _imagePath: "", _rating: 0.0, _id: "", _discount: 0)
                            let itemReference = document.data()["itemReference"] as? String ?? "No id"
                            let size = document.data()["size"] as? Int ?? 0
                            self.itemsRef.document(itemReference).getDocument { docSnap, err in
                                if let err = err {
                                    //TODO: Handle properly
                                    print(err)
                                    return
                                } else {
                                    print("full")
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
                                    print(title)
                                    newItem.title = title
                                    newItem.description = description
                                    newItem.price = price
                                    newItem.sizes = sizes
                                    newItem.availableSizes = availableSizes
                                    newItem.imagePath = imagePath
                                    newItem.rating = rating
                                    newItem.id = item_id
                                    newItem.discount = discount
                                    print(newItem)
                                    self.mainUser.cartItems.append(CartItem(_item: newItem, _size: size))
                                }
                            }
                            print(newItem)
                            
                            //TODO: add amount to firebase
                            let id = document.documentID
                            
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
