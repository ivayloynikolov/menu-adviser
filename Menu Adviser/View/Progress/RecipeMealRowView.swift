//
//  RecipeMealsRowView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 7.11.24.
//

import SwiftUI

struct RecipeMealRowView: View {
    
    @Environment(\.selectedRecipe) var selectedRecipe
    
    let recipeData: RecipeResponseData
    
    var body: some View {
        HStack {
            VStack {
                Text(recipeData.recipeName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("calories: \(recipeData.recipeNutrition.calories)")
                        .font(.caption)
                        .lineLimit(1)
                    
                    Text("fat: \(String(format: "%.2f", recipeData.recipeNutrition.fat))")
                        .font(.caption)
                        .lineLimit(1)
                    
                    Text("carb: \(String(format: "%.2f", recipeData.recipeNutrition.carb))")
                        .font(.caption)
                        .lineLimit(1)
                    
                    Text("protein: \(String(format: "%.2f", recipeData.recipeNutrition.protein))")
                        .font(.caption)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            AsyncImage(url: URL(string: recipeData.recipeImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .clipShape(.rect(cornerRadius: 15))
        }
        .onTapGesture {
            selectedRecipe.recipeData = recipeData
        }
    }
}

#Preview {
    @Previewable @State var value = RecipeResponseData(recipeId: "id", recipeName: "name", recipeDescription: "description", recipeImage: "image", recipeIngredients: ["ingredient"], recipeNutrition: RecipeNutrition(calories: 1, fat: 1, carb: 1, protein: 1), recipeType: ["type"], directions: ["direction"], preparationTimeMin: "20 min")
    RecipeMealRowView(recipeData: value)
}
