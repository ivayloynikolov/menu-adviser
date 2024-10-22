//
//  DishModel.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import Foundation
import SwiftData


@Model
class DishModel: Identifiable {
    var id: UUID
    var name: String
    var details: String
    var image: String
    var type: String
    var yields: [String]
    var ingredients: [String]
    var directions: [String]
    var macros: [String: Float]
    var calories: Int
    var servingSize: String
    
    init(id: UUID = UUID(), name: String, details: String, type: String, image: String, yields: [String], ingredients: [String], directions: [String], macros: [String : Float], calories: Int, servingSize: String) {
        self.id = id
        self.name = name
        self.details = details
        self.type = type
        self.image = image
        self.yields = yields
        self.ingredients = ingredients
        self.directions = directions
        self.macros = macros
        self.calories = calories
        self.servingSize = servingSize
    }
}
