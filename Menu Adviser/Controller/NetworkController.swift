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
    
//    let SERVER_URL: String = "http://192.168.1.112:3000/menuadviser/recipeByNutrients"
    let SERVER_URL: String = "https://betterme-api.a-pps.net/menuadviser/recipeByNutrients"
    
    private init() {}
    
    func getRecipeData(recipeRequestData: RecipeRequestData, completion: (RecipeResponseData?) -> Void) {
        
        // TODO: replace with real api request
        JSONDataController.shared.getMockRecipe(recipeRequestData: recipeRequestData, completion: { response in
            completion(response)
        })
    }
    
    func getRecipeDataFromServer(recipeRequestData: RecipeRequestData) async throws -> RecipeResponseData {
        
        // TODO: find a better way to construct query items
        let queryItems = [
            URLQueryItem(name: "recipeTypes", value: recipeRequestData.recipeTypes),
            URLQueryItem(name: "caloriesFrom", value: String(recipeRequestData.caloriesFrom)),
            URLQueryItem(name: "caloriesTo", value: String(recipeRequestData.caloriesTo)),
            URLQueryItem(name: "carbPercentageFrom", value: String(recipeRequestData.carbPercentageFrom)),
            URLQueryItem(name: "carbPercentageTo", value: String(recipeRequestData.carbPercentageTo)),
            URLQueryItem(name: "fatPercentageFrom", value: String(recipeRequestData.fatPercentageFrom)),
            URLQueryItem(name: "fatPercentageTo", value: String(recipeRequestData.fatPercentageTo)),
            URLQueryItem(name: "proteinPercentageFrom", value: String(recipeRequestData.proteinPercentageFrom)),
            URLQueryItem(name: "proteinPercentageTo", value: String(recipeRequestData.proteinPercentageTo)),
            URLQueryItem(name: "isVegan", value: String(recipeRequestData.isVegan)),
            URLQueryItem(name: "isVegetarian", value: String(recipeRequestData.isVegetarian)),
            URLQueryItem(name: "allergens", value: recipeRequestData.allergens.map{$0}.joined(separator: ","))
        ]
        
        guard let url = URL(string: SERVER_URL)?
            .appending(queryItems: queryItems)
        else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let recipeData = try JSONDecoder().decode(RecipeResponseData.self, from: data)
            return recipeData
        } catch DecodingError.keyNotFound(let key, let context) {
            throw NetworkError.decodeError(
                message: "Could not find key \(key) in JSON: \(context.debugDescription)",
                error: nil
            )
        } catch DecodingError.valueNotFound(let type, let context) {
            throw NetworkError.decodeError(
                message: "Could not find type \(type) in JSON: \(context.debugDescription)",
                error: nil
            )
        } catch DecodingError.typeMismatch(let type, let context) {
            throw NetworkError.decodeError(
                message: "Type mismatch for type \(type) in JSON: \(context.debugDescription)",
                error: nil
            )
        } catch DecodingError.dataCorrupted(let context) {
            throw NetworkError.decodeError(
                message: "Data found to be corrupted in JSON: \(context.debugDescription)",
                error: nil
            )
        } catch {
            throw NetworkError.decodeError(message: "Generic Decoding Error", error: error)
        }
    }
}
