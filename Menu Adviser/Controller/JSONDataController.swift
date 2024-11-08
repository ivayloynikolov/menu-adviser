//
//  JSONDataController.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import Foundation

class JSONDataController {
    static let shared = JSONDataController()
    
    private init() {}
    
    func loadAllergens(completion: (AllergensList?) -> Void) {
        if let url = Bundle.main.url(forResource: "allergens", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(AllergensList.self, from: data)
                
                completion(jsonData)
            } catch {
                print("error:\(error)")
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
//    func saveAllergens(allergens: AllergensList, completion: (Bool) -> Void) {
//        if let url = Bundle.main.url(forResource: "allergens", withExtension: "json") {
//            do {
//                let data = try JSONEncoder().encode(allergens)
//                try data.write(to: url)
//                
//                completion(true)
//            } catch {
//                print("error:\(error)")
//                completion(false)
//            }
//        } else {
//            completion(false)
//        }
//    }
    
    func getMockRecipe(recipeRequestData: RecipeRequestData, completion: (RecipeResponseData?) -> Void) {
        if let url = Bundle.main.url(forResource: recipeRequestData.recipeTypes, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(RecipesData.self, from: data)
                
                completion(jsonData.recipes.isEmpty ? nil : jsonData.recipes.randomElement())
            } catch {
                print("error:\(error)")
            }
        } else {
            completion(nil)
        }
    }
}
