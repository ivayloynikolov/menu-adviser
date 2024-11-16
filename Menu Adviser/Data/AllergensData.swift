//
//  AllergensData.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 5.11.24.
//

import Foundation

struct AllergenData: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    var isSelected: Bool
}

struct AllergensList: Codable {
    let allergens: [AllergenData]
}
