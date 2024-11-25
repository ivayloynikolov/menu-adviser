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
    
    var macrosDistribution: (carbPercentageFrom: Int, carbPercentageTo: Int, fatPercentageFrom: Int, fatPercentageTo: Int, proteinPercentageFrom: Int, proteinPercentageTo: Int) {
        switch self {
        case .weightLoss:
            return (
                carbPercentageFrom: 35,
                carbPercentageTo: 45,
                fatPercentageFrom: 25,
                fatPercentageTo: 30,
                proteinPercentageFrom: 30,
                proteinPercentageTo: 35
            )
        case .stayFit:
            return (
                carbPercentageFrom: 40,
                carbPercentageTo: 60,
                fatPercentageFrom: 25,
                fatPercentageTo: 30,
                proteinPercentageFrom: 15,
                proteinPercentageTo: 30
            )
        case .gainWeight:
            return (
                carbPercentageFrom: 40,
                carbPercentageTo: 55,
                fatPercentageFrom: 20,
                fatPercentageTo: 30,
                proteinPercentageFrom: 25,
                proteinPercentageTo: 30
            )
        case .undefined:
            return (
                carbPercentageFrom: 0,
                carbPercentageTo: 0,
                fatPercentageFrom: 0,
                fatPercentageTo: 0,
                proteinPercentageFrom: 0,
                proteinPercentageTo: 0
            )
        }
    }
}

enum PaceOptions: String {
    case slow = "slow"
    case normal = "normal"
    case fast = "fast"
    case undefined = "undefined"
    
    var caloriesCompensation: Int {
        switch self {
        case .slow: return 300
        case .normal: return 500
        case .fast: return 800
        case .undefined: return 0
        }
    }
}

enum RecipeTypes: String, CaseIterable {
    case breakfast
    case lunch
    case snack
    case diner
    
    var caloriesDistribution: (from: Float, to: Float) {
        switch self {
        case .breakfast: return (from: 0.2, to: 0.25)
        case .lunch: return (from: 0.3, to: 0.35)
        case .snack: return (from: 0.1, to: 0.15)
        case .diner: return (from: 0.3, to: 0.35)
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
    
    func generateDailyMenu(goal: GoalModel, preferences: MenuPreferencesModel, completion: @escaping(Result<RecipeDailyMenuData, NetworkError>) -> Void) {
        
        let recipeDailyMenuData = RecipeDailyMenuData()
        
        for type in RecipeTypes.allCases {
            requestRecipeFromServer(recipeType: type, goal: goal, preferences: preferences) { result in
                switch result {
                case .success(let responseData):
                    switch type {
                    case .breakfast: recipeDailyMenuData.breakfast = responseData
                    case .lunch: recipeDailyMenuData.lunch = responseData
                    case .snack: recipeDailyMenuData.snack = responseData
                    case .diner: recipeDailyMenuData.dinner = responseData
                    }
                    
                    if recipeDailyMenuData.isComplete {
                        completion(.success(recipeDailyMenuData))
                    }
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }
    
    func requestRecipeFromServer(recipeType: RecipeTypes, goal: GoalModel, preferences: MenuPreferencesModel, completion: @escaping(Result<RecipeResponseData, NetworkError>) -> Void) {
        
        if let macrosDistribution = GoalOptions(rawValue: goal.targetGoal)?.macrosDistribution {
            let recipeRequestData = RecipeRequestData(
                recipeTypes: recipeType.rawValue,
                caloriesFrom: Int(recipeType.caloriesDistribution.from),
                caloriesTo: Int(recipeType.caloriesDistribution.to),
                carbPercentageFrom: macrosDistribution.carbPercentageFrom,
                carbPercentageTo: macrosDistribution.carbPercentageTo,
                fatPercentageFrom: macrosDistribution.fatPercentageFrom,
                fatPercentageTo: macrosDistribution.fatPercentageTo,
                proteinPercentageFrom: macrosDistribution.proteinPercentageFrom,
                proteinPercentageTo: macrosDistribution.proteinPercentageTo,
                isVegan: preferences.isVegan,
                isVegetarian: preferences.isVegetarian,
                allergens: preferences.allergens.compactMap {$0.isSelected ? $0.name : nil}
            )
            
            NetworkController.shared.getRecipeDataFromServer(recipeRequestData: recipeRequestData, completion: { result in
                completion(result)
            })
        } else {
            fatalError("Error accessing macros distribution data") // this error should not be possible
        }
    }
}
