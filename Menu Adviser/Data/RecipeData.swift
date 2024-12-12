//
//  RecipeData.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import Foundation


struct RecipeDailyMenuData: Codable {
    var breakfast: RecipeResponseData
    var lunch: RecipeResponseData
    var snack: RecipeResponseData
    var dinner: RecipeResponseData
    
    init(breakfast: RecipeResponseData, lunch: RecipeResponseData, snack: RecipeResponseData, dinner: RecipeResponseData) {
        self.breakfast = breakfast
        self.lunch = lunch
        self.snack = snack
        self.dinner = dinner
    }
}

struct RecipeRequestData: Codable {
    let recipeTypes: String
    let caloriesFrom: Int
    let caloriesTo: Int
    let carbPercentageFrom: Int
    let carbPercentageTo: Int
    let fatPercentageFrom: Int
    let fatPercentageTo: Int
    let proteinPercentageFrom: Int
    let proteinPercentageTo: Int
    let isVegan: Bool
    let isVegetarian: Bool
    let allergens: [String]
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
