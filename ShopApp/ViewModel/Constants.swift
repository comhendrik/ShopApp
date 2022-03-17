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
                       _sizes: [45,46,45],
                       _amountOfSizes: [0,3,4],
                       _imagePath: "Off-White-x-Jordan-1-UNC-Blue-2_w900",
                       _rating: 2.5,
                       _id: "00003401",
                       _discount: 0)
