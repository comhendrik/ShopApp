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
let userRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "M1c92mRQiKdPtaNKj8tT")
let orderRef = Firestore.firestore().collection("Orders")

