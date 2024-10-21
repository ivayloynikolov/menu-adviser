//
//  RecipeData.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import Foundation

struct RecipeData: Codable {
    let name: String
    let details: String
    let type: String
    let image: String
    let yields: [String]
    let ingredients: [String]
    let directions: [String]
    let macros: [String : Float]
    let calories: Int
    let servingSize: String
}

struct recipeDataArray: Codable {
    let dataArray: [RecipeData]
}
