//
//  NetworkController.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 4.11.24.
//

import Foundation

class NetworkController {
    static let shared = NetworkController()
    
    private init() {}
    
    func getRecipeData(recipeRequestData: RecipeRequestData, completion: (RecipeResponseData?) -> Void) {
        
        // TODO: replace with real api request
        JSONDataController.shared.getMockRecipe(recipeRequestData: recipeRequestData, completion: { response in
            completion(response)
        })
    }
}
