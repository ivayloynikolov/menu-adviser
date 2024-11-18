//
//  NetworkController.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 4.11.24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodeError(message: String, error: Error?)
}

class NetworkController {
    static let shared = NetworkController()
    
    let SERVER_URL: String = "https://a-pps.net/"
    
    private init() {}
    
    func getRecipeData(recipeRequestData: RecipeRequestData, completion: (RecipeResponseData?) -> Void) {
        
        // TODO: replace with real api request
        JSONDataController.shared.getMockRecipe(recipeRequestData: recipeRequestData, completion: { response in
            completion(response)
        })
    }
    
    func getRecipeDataFromServer(recipeRequestData: RecipeRequestData, completion: (RecipeResponseData?) -> Void) {
        
        let queryItems = [
            URLQueryItem(name: "recipeTypes", value: recipeRequestData.recipeTypes),
            URLQueryItem(name: "caloriesFrom", value: String(recipeRequestData.caloriesFrom ?? 0)),
            URLQueryItem(name: "caloriesTo", value: String(recipeRequestData.caloriesTo ?? 2000)),
            URLQueryItem(name: "carbPercentageFrom", value: String(recipeRequestData.carbPercentageFrom ?? 0)),
            URLQueryItem(name: "carbPercentageTo", value: String(recipeRequestData.carbPercentageTo ?? 100)),
            URLQueryItem(name: "carbPercentageFrom", value: String(recipeRequestData.carbPercentageFrom ?? 0)),
            URLQueryItem(name: "carbPercentageTo", value: String(recipeRequestData.carbPercentageTo ?? 100)),
            URLQueryItem(name: "carbPercentageFrom", value: String(recipeRequestData.carbPercentageFrom ?? 0)),
            URLQueryItem(name: "carbPercentageTo", value: String(recipeRequestData.carbPercentageTo ?? 100))
        ]
        
        guard let url = URL(string: SERVER_URL)?
            .appending(queryItems: queryItems)
        else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                print("Invalid Response")
                return
            }
            
            guard let data else {
                print("No data received")
                return
            }
            
            do {
                let recipeData = try JSONDecoder().decode(RecipeResponseData.self, from: data)
            
            } catch {
              print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    enum CodingKeys: String, CodingKey {
      case id
      case categoryDescription = "description"
      case iconString = "icon"
    }
}
