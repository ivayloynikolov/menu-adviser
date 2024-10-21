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
    
    // availableFoodData.json describes specific foods that cen be excluded from the resulting recipes when the menu is generated
    // TODO: complete the list with all supported items
    func loadAvailableFoodData(completion: (FoodDataArray?) -> Void) {
        if let url = Bundle.main.url(forResource: "availableFoodData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(FoodDataArray.self, from: data)
                
                completion(jsonData)
            } catch {
                print("error:\(error)")
            }
        }
        
        completion(nil)
    }
    
    // recipeApiMock.json contains a response structure of the actual API, which will be used in the production
    func loadRecipeApiMockData(completion: (recipeDataArray?) -> Void) {
        if let url = Bundle.main.url(forResource: "recipeApiMock", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(recipeDataArray.self, from: data)
                
                completion(jsonData)
            } catch {
                print("error:\(error)")
            }
        }
        
        completion(nil)
    }
}
