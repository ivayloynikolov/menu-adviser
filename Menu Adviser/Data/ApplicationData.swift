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
}
