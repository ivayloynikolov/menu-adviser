//
//  MenuPreferencesModel.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 7.11.24.
//

import Foundation
import SwiftData

@Model
class MenuPreferencesModel: Identifiable {
    var id: UUID
    var allergens: [AllergenData]
    var isVegan: Bool
    var isVegetarian: Bool
    
    init(id: UUID = UUID(), allergens: [AllergenData], isVegan: Bool, isVegetarian: Bool) {
        self.id = id
        self.allergens = allergens
        self.isVegan = isVegan
        self.isVegetarian = isVegetarian
    }
}
