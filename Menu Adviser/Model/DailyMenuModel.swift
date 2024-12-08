//
//  ProgressModel.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 2.11.24.
//

import Foundation
import SwiftData

@Model
class DailyMenuModel: Identifiable {
    @Attribute(.unique) var id: Int
    var breakfast: RecipeResponseData
    var lunch: RecipeResponseData
    var snack: RecipeResponseData
    var dinner: RecipeResponseData
    var calculatedDailyCalories: Int
    
    var menuCalories: Int {
        return breakfast.recipeNutrition.calories + lunch.recipeNutrition.calories + snack.recipeNutrition.calories + dinner.recipeNutrition.calories
    }
    
    init(id: Int, breakfast: RecipeResponseData, lunch: RecipeResponseData, snack: RecipeResponseData, dinner: RecipeResponseData, calculatedDailyCalories: Int) {
        self.id = id
        self.breakfast = breakfast
        self.lunch = lunch
        self.snack = snack
        self.dinner = dinner
        self.calculatedDailyCalories = calculatedDailyCalories
    }
}
