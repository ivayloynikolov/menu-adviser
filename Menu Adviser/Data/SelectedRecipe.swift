//
//  DataExtensions.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 7.11.24.
//

import SwiftUI

@Observable
class SelectedRecipe {
    var recipeData: RecipeResponseData?
    
    var isRecipeSelected: Binding<Bool> {
        Binding(
            get: { self.recipeData != nil },
            set: {
                if !$0 {
                    self.recipeData = nil
                }
            }
        )
    }
}
