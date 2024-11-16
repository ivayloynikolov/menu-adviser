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
    var targetGoal: String
    var targetWeight: Float
    var targetCalories: Int
    var targetBmi: Float
    var estimatedDays: Int
    var targetActivity: String
    var progressPace: String
    
    init(id: UUID = UUID(), targetGoal: String, targetWeight: Float, targetCalories: Int, targetBmi: Float, estimatedDays: Int, targetActivity: String, progressPace: String) {
        self.id = id
        self.targetGoal = targetGoal
        self.targetWeight = targetWeight
        self.targetCalories = targetCalories
        self.targetBmi = targetBmi
        self.estimatedDays = estimatedDays
        self.targetActivity = targetActivity
        self.progressPace = progressPace
    }
}
