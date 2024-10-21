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
    var bmi: Float
    
    init(id: UUID = UUID(), name: String, age: Int, sex: String, weight: Float, height: Int, activity: String, bmi: Float) {
        self.id = id
        self.name = name
        self.age = age
        self.sex = sex
        self.weight = weight
        self.height = height
        self.activity = activity
        self.bmi = bmi
    }
}
