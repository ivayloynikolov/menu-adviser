//
//  RecipeDetailsView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 7.11.24.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    @Environment(\.selectedRecipe) var selectedRecipe
    
    var body: some View {
        ScrollView {
            if selectedRecipe.recipeData != nil {
                VStack {
                    Text(selectedRecipe.recipeData!.recipeName)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .multilineTextAlignment(.center)
                    
                    Text(selectedRecipe.recipeData!.recipeDescription)
                        .padding(.bottom, 30)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Type")
                                .font(.title)
                            
                            Text(selectedRecipe.recipeData!.recipeType.joined(separator: ", "))
                                .padding(.bottom, 10)
                            
                            Text("Macros")
                                .font(.title)
                                .padding(.top, 10)
                            
                            VStack(alignment: .leading) {
                                Text("calories: \(selectedRecipe.recipeData!.recipeNutrition.calories)")
                                
                                Text("fat: \(String(format: "%.2f", selectedRecipe.recipeData!.recipeNutrition.fat))")
                                
                                Text("carb: \(String(format: "%.2f", selectedRecipe.recipeData!.recipeNutrition.carb))")
                                
                                Text("protein: \(String(format: "%.2f", selectedRecipe.recipeData!.recipeNutrition.protein))")
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        
                        Spacer()
                        
                        VStack {
                            AsyncImage(url: URL(string: selectedRecipe.recipeData!.recipeImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.4)
                            .clipShape(.rect(cornerRadius: 25))
                            
                            Text("Preparing time:")
                                .bold()
                                .padding(.top, 5)
                            
                            Text("\(selectedRecipe.recipeData!.preparationTimeMin) min.")
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    
                    Text("Ingredients")
                        .font(.title)
                        .padding(.top, 20)
                    
                    ForEach(Array(selectedRecipe.recipeData!.recipeIngredients.enumerated()), id: \.0) { index, ingredient in
                        Text("\(index + 1). \(ingredient)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text("Directions")
                        .font(.title)
                        .padding(.top, 20)
                    
                    ForEach(Array(selectedRecipe.recipeData!.directions.enumerated()), id: \.0) { index, direction in
                        Text("\(index + 1). \(direction)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 30)
            }
        }
    }
}

#Preview {
    RecipeDetailsView()
}
