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
