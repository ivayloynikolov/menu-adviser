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
}
