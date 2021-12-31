//
//  ItemViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import Foundation
import SwiftUI

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

struct CartItem: Identifiable {
    var item: Item
    var size: Int
    var id: String
    var amount: Int
    
    init(_item: Item, _size: Int) {
        item = _item
        size = _size
        id = _item.id + String(size)
        amount = 1
    }
}

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var cartItems: [CartItem] = []
    @Published var favoriteItems: [Item] = []
    @Published var showProgressView = true
    //TODO: stuff with firebase
    init() {
        self.getItems()
        self.getCartItems()
        self.getFavoriteItems()
    }
    
    func increaseNumber() {
        cartItems[0].amount += 1
    }
    
    func getItems() {
        items = [Item(_title: "Jordan 1",
                      _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                      _price: 129.99,
                      _sizes: [41,42,43,44,45,46,47],
                      _availableSizes: [41,42,46,47],
                      _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                      _rating: 2.5,
                      _id: "00003401",
                      _discount: 0
      ),
                   Item(_title: "Jordan 1",
                                   _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                   _price: 129.99,
                                   _sizes: [41,42,43,44,45,46,47],
                                   _availableSizes: [41,42,46,47],
                                    _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                   _rating: 2.5,
                                   _id: "00055001",
                        _discount: 45
                   ), Item(_title: "jordan 1",
                           _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                           _price: 129.99,
                           _sizes: [41,42,43,44,45,46,47],
                           _availableSizes: [41,42,46,47],
                           _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                           _rating: 2.5,
                           _id: "00340001",
                           _discount: 80
           ), Item(_title: "Jordan 1",
                   _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                   _price: 129.99,
                   _sizes: [41,42,43,44,45,46,47],
                   _availableSizes: [41,42,46,47],
                   _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                   _rating: 2.5,
                   _id: "0000001",
                   _discount: 90
   )]
        showProgressView = false
    }
    
    func getCartItems() {
        showProgressView = true
        cartItems = [CartItem(_item: Item(_title: "Jordan 1",
                                          _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                          _price: 129.99,
                                          _sizes: [41,42,43,44,45,46,47],
                                          _availableSizes: [41,42,46,47],
                                          _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                          _rating: 2.5,
                                          _id: "00003401",
                                          _discount: 0
                          ), _size: 45),
                     CartItem(_item: Item(_title: "Jordan 1",
                                                       _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                                                       _price: 129.99,
                                                       _sizes: [41,42,43,44,45,46,47],
                                                       _availableSizes: [41,42,46,47],
                                                       _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                                                       _rating: 2.5,
                                                       _id: "00003401",
                                                       _discount: 50
                                       ), _size: 42)]
        showProgressView = false
    }
    

    
    func addCartItem(itemToAdd: Item, size: Int) {
        
        cartItems.append(CartItem(_item: itemToAdd, _size: size))
    }
    
    func getFavoriteItems() {
        showProgressView = true
        favoriteItems = [Item(_title: "Jordan 1",
                              _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                              _price: 129.99,
                              _sizes: [41,42,43,44,45,46,47],
                              _availableSizes: [41,42,46,47],
                              _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                              _rating: 2.5,
                              _id: "00003401",
                              _discount: 0
              )]
        showProgressView = false
    }
    
    func addFavoriteItem(itemToAdd: Item) {
        
        favoriteItems.append(itemToAdd)
    }
}
