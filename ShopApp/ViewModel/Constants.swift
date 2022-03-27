//
//  Constants.swift
//  ShopApp
//
//  Created by Hendrik Steen on 06.01.22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

let itemsRef = Firestore.firestore().collection("Items")
let orderRef = Firestore.firestore().collection("Orders")
let previewItem = Item(_title: "jordan 1",
                       _description: "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad min",
                       _price: 129.99,
                       _sizes: [ShoeSize(_size: 45, _amount: 5), ShoeSize(_size: 46, _amount: 0), ShoeSize(_size: 47, _amount: 5), ShoeSize(_size: 48, _amount: 0)],
                       _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                       _rating: 2.5,
                       _id: "00003401",
                       _discount: 0)
let userID = Auth.auth().currentUser?.uid ?? "no uid"
