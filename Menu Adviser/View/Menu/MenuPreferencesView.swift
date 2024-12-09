//
//  SelectFoodView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import SwiftUI
import SwiftData

struct MenuPreferencesView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query private var menuPreferences: [MenuPreferencesModel]
    
    @State private var isVegan: Bool = false
    @State private var isVegetarian: Bool = false
    @State private var allergens: [AllergenData] = []
    
    @State private var isAlertPresented = false
    @State private var appDataError: AppDataError?
    
    func saveContext() {
        do {
            try modelContext.save()
        } catch {
            appDataError = .unsuccessfulSave
            isAlertPresented = true
        }
    }
    
    var body: some View {
        VStack {
            Text("Menu Preferences")
                .font(.title)
            
            Toggle("Vegan menu", isOn: $isVegan)
                .padding(EdgeInsets(top: 20.0, leading: 20.0, bottom: 5.0, trailing: 20.0))
                .onChange(of: isVegan) {
                    if isVegan {
                        isVegetarian = false
                    }
                    
                    menuPreferences.first!.isVegan = isVegan
                    menuPreferences.first!.isVegetarian = isVegetarian
                    
                    saveContext()
                }
            
            Toggle("Vegetarian menu", isOn: $isVegetarian)
                .padding(EdgeInsets(top: 5.0, leading: 20.0, bottom: 30.0, trailing: 20.0))
                .onChange(of: isVegetarian) {
                    if isVegetarian {
                        isVegan = false
                    }
                    
                    menuPreferences.first!.isVegan = isVegan
                    menuPreferences.first!.isVegetarian = isVegetarian
                    
                    saveContext()
                }
            
            Text("Allergens included in the recipes")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            List($allergens) { $allergen in
                AllergenRowView(allergen: $allergen)
            }
            .padding(.horizontal, 0)
            .onChange(of: allergens) { oldValue, newValue in
                menuPreferences.first!.allergens = allergens
                
                saveContext()
            }
        }
        .alert(Text(appDataError?.failureReason ?? ""), isPresented: $isAlertPresented) {
            Button("Ok", role: .cancel) {
                isAlertPresented = false
            }
        } message: {
            Text("\n\(appDataError?.recoverySuggestion ?? "") \n\n\(appDataError?.errorDescription ?? "")")
        }
        .task {
            if menuPreferences.isEmpty {
                AppData.shared.getAllergens { allergensList in
                    if let data = allergensList {
                        allergens = data.allergens
                        isVegan = false
                        isVegetarian = false
                        
                        let preferences = MenuPreferencesModel(allergens: allergens, isVegan: isVegan, isVegetarian: isVegetarian)
                        
                        modelContext.insert(preferences)
                        
                        saveContext()
                    }
                }
            } else {
                isVegan = menuPreferences.first!.isVegan
                isVegetarian = menuPreferences.first!.isVegetarian
                allergens = menuPreferences.first!.allergens
            }
        }
    }
}

#Preview {
    MenuPreferencesView()
        .modelContainer(for: [MenuPreferencesModel.self], inMemory: true)
}
