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
let shoeRef = Firestore.firestore().collection("Shoes")
let pulloverRef = Firestore.firestore().collection("Pullover")
let shirtsRef = Firestore.firestore().collection("Shirts")
let orderRef = Firestore.firestore().collection("Orders")

