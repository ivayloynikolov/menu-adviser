//
//  SelectFoodView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import SwiftUI
import SwiftData

struct SelectFoodView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var isMenuGenerated: Bool
    
    @State var isVegan: Bool = false
    @State var isVegetarian: Bool = false
    @State var availableFood: [FoodData] = []
    
    var body: some View {
        VStack {
            Text("Generate menu")
                .font(.title)
            
            Toggle("Enable only Vegan food", isOn: $isVegan)
                .padding(EdgeInsets(top: 20.0, leading: 20.0, bottom: 5.0, trailing: 20.0))
            
            Toggle("Enable only Vegetarian food", isOn: $isVegetarian)
                .padding(EdgeInsets(top: 5.0, leading: 20.0, bottom: 30.0, trailing: 20.0))
            
            Text("Included Food in Recipes")
                .fontWeight(.bold)
            
            List(availableFood) { food in
                AvailableFoodRowView(food: food.name)
            }
            .padding(.horizontal, 0)
            
            HStack {
                Button(action: {
                    generateMenu()
                }, label: {
                    Text("Generate Daily Menu")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20.0)
                })
                .background(.orange, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
            }
            .padding(EdgeInsets(top: 10.0, leading: 30.0, bottom: 20.0, trailing: 30.0))
        }
        .padding(.top, 20)
        .task {
            JSONDataController.shared.loadAvailableFoodData { foodData in
                if let data = foodData {
                    availableFood = data.dataArray
                }
            }
        }
    }
        
    func generateMenu() {
        // TODO: replace with real api calls
        JSONDataController.shared.loadRecipeApiMockData { recipeDataArray in
            if let data = recipeDataArray {
                data.dataArray.forEach { recipe in
                    let dish = DishModel(name: recipe.name, details: recipe.details, type: recipe.type, image: recipe.image, yields: recipe.yields, ingredients: recipe.ingredients, directions: recipe.directions, macros: recipe.macros, calories: recipe.calories, servingSize: recipe.servingSize)
                    
                    modelContext.insert(dish)
                    do {
                        try modelContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    SelectFoodView(isMenuGenerated: $value)
}
