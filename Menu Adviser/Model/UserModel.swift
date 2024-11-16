//
//  UserModel.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 16.10.24.
//

import Foundation
import SwiftData

@Model
class UserModel: Identifiable {
    var id: UUID
    var name: String
    var age: Int
    var sex: String
    var weight: Float
    var height: Int
    var activity: String
    
    var currentBmi: Float {
        var bmi: Float = 0.0
        
        if height > 0 && weight > 0 {
            let heightSquare: Float = (Float(height) * 0.01) * (Float(height) * 0.01)
            bmi = weight / heightSquare
        }
        
        return bmi
    }
    
    var currentDailyCalories: Int {
        var calories: Int = 0
        
        if sex != SexOptions.undefined.rawValue &&
            weight > 0 &&
            height > 0 &&
            activity != ActivityOptions.undefined.rawValue {
            
            var bmr: Float = 0.0
            var amr: Float = 0.0
            
            if sex == SexOptions.male.rawValue {
                bmr = (9.65 * weight) + (573 * Float(height) * 0.01) - (5.08 * Float(age))
            } else {
                bmr = (7.38 * weight) + (607 * Float(height) * 0.01) - (2.31 * Float(age))
            }
            
            switch activity {
            case ActivityOptions.low.rawValue: // 1-3 days / week
                amr = bmr * 1.375
            case ActivityOptions.moderate.rawValue: // 3-5 days / week
                amr = bmr * 1.55
            case ActivityOptions.high.rawValue: // 6-7 days / week
                amr = bmr * 1.725
            default:
                amr = 0
            }
            
            calories = Int(amr)
        }
        
        return calories
    }
    
    init(id: UUID = UUID(), name: String, age: Int, sex: String, weight: Float, height: Int, activity: String) {
        self.id = id
        self.name = name
        self.age = age
        self.sex = sex
        self.weight = weight
        self.height = height
        self.activity = activity
    }
}
