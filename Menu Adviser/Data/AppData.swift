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
                carbPercentageFrom: 25,
                carbPercentageTo: 55,
                fatPercentageFrom: 15,
                fatPercentageTo: 40,
                proteinPercentageFrom: 20,
                proteinPercentageTo: 45
            )
        case .stayFit:
            return (
                carbPercentageFrom: 30,
                carbPercentageTo: 70,
                fatPercentageFrom: 15,
                fatPercentageTo: 40,
                proteinPercentageFrom: 5,
                proteinPercentageTo: 40
            )
        case .gainWeight:
            return (
                carbPercentageFrom: 30,
                carbPercentageTo: 65,
                fatPercentageFrom: 10,
                fatPercentageTo: 40,
                proteinPercentageFrom: 15,
                proteinPercentageTo: 40
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
    case dinner
    
    var caloriesDistribution: (from: Float, to: Float) {
        switch self {
        case .breakfast: return (from: 0.15, to: 0.3)
        case .lunch: return (from: 0.25, to: 0.4)
        case .snack: return (from: 0.05, to: 0.2)
        case .dinner: return (from: 0.25, to: 0.4)
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
    
    func calculateDefaultDailyCalories(goals: [GoalModel], dailyMenus: [DailyMenuModel]) -> Int {
        guard  !goals.isEmpty else { return 0 }
        
        if dailyMenus.isEmpty {
            return goals.first!.targetCalories
        } else {
            var sumOfCaloriesForDaysWithMenu = 0
            
            for menu in dailyMenus {
                sumOfCaloriesForDaysWithMenu += menu.menuCalories
            }
            
            let totalCaloriesToTheEnd = goals.first!.targetCalories * goals.first!.estimatedDays
            
            let calories = (totalCaloriesToTheEnd - sumOfCaloriesForDaysWithMenu) / (goals.first!.estimatedDays - dailyMenus.count)
            
            return calories
        }
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
    
    func generateDailyMenu(goal: GoalModel, defaultDailyCalories: Int, preferences: MenuPreferencesModel) async throws -> RecipeDailyMenuData {
        
        var breakfastData: RecipeResponseData?
        var lunchData: RecipeResponseData?
        var snackData: RecipeResponseData?
        var dinnerData: RecipeResponseData?
        
        for type in RecipeTypes.allCases {
            do {
                let responseData = try await requestRecipeFromServer(recipeType: type, goal: goal, defaultDailyCalories: defaultDailyCalories, preferences: preferences)
                
                switch type {
                case .breakfast: breakfastData = responseData
                case .lunch: lunchData = responseData
                case .snack: snackData = responseData
                case .dinner: dinnerData = responseData
                }
            } catch let networkError {
                throw networkError
            }
        }
        
        return RecipeDailyMenuData(breakfast: breakfastData!, lunch: lunchData!, snack: snackData!, dinner: dinnerData!)
    }
    
    func requestRecipeFromServer(recipeType: RecipeTypes, goal: GoalModel, defaultDailyCalories: Int, preferences: MenuPreferencesModel) async throws -> RecipeResponseData {
        
        if let macrosDistribution = GoalOptions(rawValue: goal.targetGoal)?.macrosDistribution {
            let recipeRequestData = RecipeRequestData(
                recipeTypes: recipeType.rawValue,
                caloriesFrom: Int(Float(defaultDailyCalories) * recipeType.caloriesDistribution.from),
                caloriesTo: Int(Float(defaultDailyCalories) * recipeType.caloriesDistribution.to),
                carbPercentageFrom: macrosDistribution.carbPercentageFrom,
                carbPercentageTo: macrosDistribution.carbPercentageTo,
                fatPercentageFrom: macrosDistribution.fatPercentageFrom,
                fatPercentageTo: macrosDistribution.fatPercentageTo,
                proteinPercentageFrom: macrosDistribution.proteinPercentageFrom,
                proteinPercentageTo: macrosDistribution.proteinPercentageTo,
                isVegan: preferences.isVegan,
                isVegetarian: preferences.isVegetarian,
                allergens: preferences.allergens.compactMap {!$0.isSelected ? $0.name : nil}
            )
            
            do {
                let result = try await NetworkController.shared.getRecipeDataFromServer(recipeRequestData: recipeRequestData)
                
                return result
            } catch let networkError {
                throw networkError
            }
            
        } else {
            fatalError("Error accessing macros distribution data") // this error should not be possible
        }
    }
}
