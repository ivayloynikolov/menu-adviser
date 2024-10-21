//
//  GoalsModel.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 20.10.24.
//

import Foundation
import SwiftData

@Model
class GoalsModel: Identifiable {
    var id: UUID
    var goal: String
    var targetWeight: Float
    var targetCalories: Int
    var targetBMI: Float
    var estimatedDays: Int
    var targetActivity: String
    
    init(id: UUID = UUID(), goal: String, targetWeight: Float, targetCalories: Int, targetBMI: Float, estimatedDays: Int, targetActivity: String) {
        self.id = id
        self.goal = goal
        self.targetWeight = targetWeight
        self.targetCalories = targetCalories
        self.targetBMI = targetBMI
        self.estimatedDays = estimatedDays
        self.targetActivity = targetActivity
    }
}
