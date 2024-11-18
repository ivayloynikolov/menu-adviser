//
//  ApplicationData.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 24.10.24.
//

import Foundation

enum SexOptions: String {
    case male, female, undefined
}

enum ActivityOptions: String {
    case low, moderate, high, undefined
}

enum GoalOptions: String {
    case weightLoss = "weight loss"
    case stayFit = "stay fit"
    case gainWeight = "gain weight"
    case undefined = "undefined"
}

enum PaceOptions: String {
    case slow = "slow"
    case normal = "normal"
    case fast = "fast"
    case undefined = "undefined"
    
    var caloriesCompensation: Int {
        switch self {
        case .slow:
            return 300
        case .normal:
            return 500
        case .fast:
            return 800
        case .undefined:
            return 0
        }
    }
}

class AppData {
    static let shared = AppData()
    
    private var _allergens: AllergensList?
    
    private init() {}
    
    func calculateBmi(weight: Float, height: Int) -> Float {
        var bmi: Float = 0.0
        
        if height > 0 && weight > 0 {
            let heightSquare: Float = (Float(height) * 0.01) * (Float(height) * 0.01)
            bmi = weight / heightSquare
        }
        
        return bmi
    }
    
    func calculateEstimatedDays(weightDifference: Int, progressPace: PaceOptions) -> Int {
        var days: Int = 0
        
        let caloriesPerKgMuscle: Int = 6300
        let caloriesPerKgFat: Int = 7700
        
        let totalCalories: Int = weightDifference * (weightDifference > 0 ? caloriesPerKgMuscle : -caloriesPerKgFat)
        
        days = totalCalories / progressPace.caloriesCompensation
        
        return days
    }
    
    func getAllergens(completion: (AllergensList?) -> Void) {
        if _allergens != nil {
            completion(_allergens)
        } else {
            JSONDataController.shared.loadAllergens { allergensList in
                _allergens = allergensList
                
                completion(_allergens)
            }
        }
    }
    
//    func setAllergens(allergens: AllergensList, completion: (Bool) -> Void) {
//        _allergens = allergens
//        
//        JSONDataController.shared.saveAllergens(allergens: allergens) { isSaveSuccessful in
//            completion(isSaveSuccessful)
//        }
//    }
    
    func generateDailyMenu(user: UserModel, goal: GoalModel, completion: (RecipeDailyMenuData?) -> Void) {
        
        let recipeDailyMenuData = RecipeDailyMenuData()
        
        generateBreakfast(user: user, goal: goal) { breakfastResponseData in
            recipeDailyMenuData.breakfast = breakfastResponseData
        
            if recipeDailyMenuData.isComplete {
                completion(recipeDailyMenuData)
            }
        }
        
        generateLunch(user: user, goal: goal) { lunchResponseData in
            recipeDailyMenuData.lunch = lunchResponseData
            
            if recipeDailyMenuData.isComplete {
                completion(recipeDailyMenuData)
            }
        }
        
        generateSnack(user: user, goal: goal) { snackResponseData in
            recipeDailyMenuData.snack = snackResponseData
            
            if recipeDailyMenuData.isComplete {
                completion(recipeDailyMenuData)
            }
        }
        
        generateDinner(user: user, goal: goal) { dinnerResponseData in
            recipeDailyMenuData.dinner = dinnerResponseData
            
            if recipeDailyMenuData.isComplete {
                completion(recipeDailyMenuData)
            }
        }
    }
    
    func generateBreakfast(user: UserModel, goal: GoalModel, completion: (RecipeResponseData?) -> Void) {
        
        let recipeRequestData = RecipeRequestData(recipeId: nil, recipeTypes: "breakfast", caloriesFrom: nil, caloriesTo: nil, carbPercentageFrom: nil, carbPercentageTo: nil, fatPercentageFrom: nil, fatPercentageTo: nil, proteinPercentageFrom: nil, proteinPercentageTo: nil)
        
        NetworkController.shared.getRecipeData(recipeRequestData: recipeRequestData, completion: { recipeResponseData in
            completion(recipeResponseData)
        })
    }
    
    func generateLunch(user: UserModel, goal: GoalModel, completion: (RecipeResponseData?) -> Void) {
        
        let recipeRequestData = RecipeRequestData(recipeId: nil, recipeTypes: "lunch", caloriesFrom: nil, caloriesTo: nil, carbPercentageFrom: nil, carbPercentageTo: nil, fatPercentageFrom: nil, fatPercentageTo: nil, proteinPercentageFrom: nil, proteinPercentageTo: nil)
        
        NetworkController.shared.getRecipeData(recipeRequestData: recipeRequestData, completion: { recipeResponseData in
            completion(recipeResponseData)
        })
    }
    
    func generateSnack(user: UserModel, goal: GoalModel, completion: (RecipeResponseData?) -> Void) {
        
        let recipeRequestData = RecipeRequestData(recipeId: nil, recipeTypes: "snack", caloriesFrom: nil, caloriesTo: nil, carbPercentageFrom: nil, carbPercentageTo: nil, fatPercentageFrom: nil, fatPercentageTo: nil, proteinPercentageFrom: nil, proteinPercentageTo: nil)
        
        NetworkController.shared.getRecipeData(recipeRequestData: recipeRequestData, completion: { recipeResponseData in
            completion(recipeResponseData)
        })
    }
    
    func generateDinner(user: UserModel, goal: GoalModel, completion: (RecipeResponseData?) -> Void) {
        
        let recipeRequestData = RecipeRequestData(recipeId: nil, recipeTypes: "dinner", caloriesFrom: nil, caloriesTo: nil, carbPercentageFrom: nil, carbPercentageTo: nil, fatPercentageFrom: nil, fatPercentageTo: nil, proteinPercentageFrom: nil, proteinPercentageTo: nil)
        
        NetworkController.shared.getRecipeData(recipeRequestData: recipeRequestData, completion: { recipeResponseData in
            completion(recipeResponseData)
        })
    }
}
