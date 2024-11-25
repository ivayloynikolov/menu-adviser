//
//  DailyMenuView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 4.11.24.
//

import SwiftUI
import SwiftData

struct DailyMenuView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.selectedRecipe) var selectedRecipe
    
    @Query private var dailyMenus: [DailyMenuModel]
    @Query private var users: [UserModel]
    @Query private var goals: [GoalModel]
    @Query private var preferences: [MenuPreferencesModel]
    
    @State private var isAlertPresented: Bool = false
    @State private var errorMessage: String = ""
    
    let currentDay: Int
    
    init(currentDay: Int) {
        self.currentDay = currentDay
        _dailyMenus = Query(filter: #Predicate { $0.id == currentDay } )
    }
           
    var body: some View {
        VStack {
            if dailyMenus.isEmpty {
                Text("You don't have a menu generated for the day yet.")
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button(action: {
                    AppData.shared.generateDailyMenu(goal: goals.first!, preferences: preferences.first!) { result in
                        switch result {
                        case .success(let recipeDailyMenuData):
                            errorMessage = ""
                            
                            let dailyMenu = DailyMenuModel(
                                id: currentDay,
                                // breakfast, lunch, snack and dinner are confirmed as not nil in AppData
                                breakfast: recipeDailyMenuData.breakfast!,
                                lunch: recipeDailyMenuData.lunch!,
                                snack: recipeDailyMenuData.snack!,
                                dinner: recipeDailyMenuData.dinner!
                            )
                            
                            modelContext.insert(dailyMenu)
                        case .failure(let error):
                            switch error {
                            case .decodeError(let message, _):
                                errorMessage = message
                            case .invalidResponse:
                                errorMessage = "Invalid Response!"
                            case .invalidURL:
                                errorMessage = "Invalid URL!"
                            case .noData:
                                errorMessage = "No Data!"
                            }
                            
                            isAlertPresented = true
                        }
                    }
                }, label: {
                    Text("Generate Daily Menu")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15.0)
                })
                .background(.orange, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.bottom, 10)
                .alert("Error getting data from server", isPresented: $isAlertPresented) {
                    Button("OK", role: .cancel) { }
                }
            } else {
                ScrollView(.vertical) {
                    Text("Breakfast")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RecipeMealRowView(recipeData: dailyMenus.first!.breakfast)
                    
                    Divider()
                    
                    Text("Lunch")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RecipeMealRowView(recipeData: dailyMenus.first!.lunch)
                    
                    Divider()
                    
                    Text("Snack")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RecipeMealRowView(recipeData: dailyMenus.first!.snack)
                    
                    Divider()
                    
                    Text("Dinner")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RecipeMealRowView(recipeData: dailyMenus.first!.dinner)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

#Preview {
    DailyMenuView(currentDay: 1)
        .modelContainer(for: [GoalModel.self, UserModel.self, DailyMenuModel.self, MenuPreferencesModel.self], inMemory: true)
}
