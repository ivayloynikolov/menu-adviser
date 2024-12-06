//
//  ErrorData.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.12.24.
//

import Foundation

enum AppDataError: Error, LocalizedError {
    case invalidInput
    case unsuccessfulSave
    case unsuccessfulDelete
    case deleteUserWarning
    case deleteGoalWarning
    
    var failureReason: String? {
        switch self {
        case .invalidInput: return "Invalid input"
        case .unsuccessfulSave: return "Error saving data"
        case .unsuccessfulDelete: return "Error deleting data"
        case .deleteUserWarning: return "Delete confirmation"
        case .deleteGoalWarning: return "Delete confirmation"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidInput: return "Please, fill all of the available fields"
        case .unsuccessfulSave: return "Please, try again"
        case .unsuccessfulDelete: return "Please, try again"
        case .deleteUserWarning: return "Deleting user will also delete goals and generated menus!"
        case .deleteGoalWarning: return "Deleting goal will also delete generated menus!"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidInput: return "All fields are required"
        case .unsuccessfulSave: return "There is some problem saving your data"
        case .unsuccessfulDelete: return "There is some problem deleting your data"
        case .deleteUserWarning: return "Are you sure?"
        case .deleteGoalWarning: return "Are you sure?"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodeError(message: String, error: Error?)
    
    var failureReason: String? {
        switch self {
        case .invalidURL: return "Invalid url"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .decodeError: return "Decoding error"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL: return "Please, check your goal data and try again"
        case .invalidResponse: return "Please, check your goal data and try again"
        case .noData: return "Please, check your goal data and try again"
        case .decodeError: return "Please, check your goal data and try again"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The provided url is invalid"
        case .invalidResponse: return "Received response is invalid"
        case .noData: return "There is no data recieved"
        case .decodeError(let message, _): return message
        }
    }
}
