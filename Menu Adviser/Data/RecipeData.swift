//
//  RecipeData.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import Foundation


class RecipeDailyMenuData: Codable {
    var breakfast: RecipeResponseData?
    var lunch: RecipeResponseData?
    var snack: RecipeResponseData?
    var dinner: RecipeResponseData?
    
    var isComplete: Bool {
        if breakfast != nil && lunch != nil && snack != nil && dinner != nil {
            return true
        } else {
            return false
        }
    }
    
    init() {}
}

struct RecipeRequestData: Codable {
    let recipeId: String?
    let recipeTypes: String?
    let caloriesFrom: Int?
    let caloriesTo: Int?
    let carbPercentageFrom: Int?
    let carbPercentageTo: Int?
    let fatPercentageFrom: Int?
    let fatPercentageTo: Int?
    let proteinPercentageFrom: Int?
    let proteinPercentageTo: Int?
}

struct RecipeResponseData: Codable {
    let recipeId: String
    let recipeName: String
    let recipeDescription: String
    let recipeImage: String
    let recipeIngredients: [String]
    let recipeNutrition: RecipeNutrition
    let recipeType: [String]
    let directions: [String]
    let preparationTimeMin: String
}

struct RecipeNutrition: Codable {
    let calories: Int
    let fat: Float
    let carb: Float
    let protein: Float
}

struct RecipesData: Codable {
    let recipes: [RecipeResponseData]
}
