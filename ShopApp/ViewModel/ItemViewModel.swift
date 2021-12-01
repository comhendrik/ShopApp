//
//  ItemViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import Foundation
import SwiftUI

struct Item {
    var title: String
    var description: String
    var gradient: [Color]
    var price: Double
    var sizes: [Int]
    var availableSizes: [Int]
    var colors: [Color]
    var availableColors: [Color]
    var imagePaths: [String]
    var rating: Float
    
    init(_title: String, _description: String, _price: Double, _gradient: [Color], _sizes: [Int], _availableSizes: [Int], _colors: [Color], _availableColors: [Color], _imagePaths: [String], _rating: Float) {
        title = _title
        description = _description
        price = _price
        gradient = _gradient
        sizes = _sizes
        availableSizes = _availableSizes
        colors = _colors
        availableColors = _availableColors
        imagePaths = _imagePaths
        rating = _rating
    }
}
