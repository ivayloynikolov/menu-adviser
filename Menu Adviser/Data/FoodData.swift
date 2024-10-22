//
//  FoodData.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import Foundation

struct FoodData: Codable, Identifiable {
    let id: Int
    let name: String
    let isVegan: Bool
    let isVegetarian: Bool
}

struct FoodDataArray: Codable {
    let dataArray: [FoodData]
}
