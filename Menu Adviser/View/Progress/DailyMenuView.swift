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
    
    @Query private var dailyMenus: [DailyMenuModel]
    @Query private var users: [UserModel]
    @Query private var goals: [GoalModel]
    @Query private var preferences: [MenuPreferencesModel]
    
    @State private var isGeneratingInProgress: Bool = false
    @State private var isAlertPresented: Bool = false
    @State private var errorMessage: String = ""
    
    let currentDay: Int
    
    var isEnabled: Bool {
        return dailyMenus.count == currentDay - 1
    }
           
    var body: some View {
        VStack {
            Text("Daily menu")
                .bold()
                .font(.title)
                .frame(alignment: .center)
                .padding(.top, 30)
            
            if isGeneratingInProgress {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(.circular)
                
                Text("Generating Daily Menu ...")
                
                Spacer()
            } else {
                if dailyMenus.count < currentDay {
                    Text("There is no generated menu for this day yet.")
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                    
                    Text("Daily menus can be generated only in a subsequent order.")
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    if isEnabled {
                        Button(action: {
                            isGeneratingInProgress = true
                            
                            Task {
                                do {
                                    let recipeDailyMenuData = try await AppData.shared.generateDailyMenu(
                                        goal: goals.first!,
                                        defaultDailyCalories: AppData.shared.calculateDefaultDailyCalories(
                                            goals: goals,
                                            dailyMenus: dailyMenus
                                        ),
                                        preferences: preferences.first!
                                    )
                                    
                                    errorMessage = ""
                                    
                                    let dailyMenu = DailyMenuModel(
                                        id: currentDay,
                                        // breakfast, lunch, snack and dinner are confirmed as not nil in AppData
                                        breakfast: recipeDailyMenuData.breakfast!,
                                        lunch: recipeDailyMenuData.lunch!,
                                        snack: recipeDailyMenuData.snack!,
                                        dinner: recipeDailyMenuData.dinner!,
                                        calculatedDailyCalories: AppData.shared.calculateDefaultDailyCalories(goals: goals, dailyMenus: dailyMenus)
                                    )
                                    
                                    isGeneratingInProgress = false
                                    
                                    modelContext.insert(dailyMenu)
                                    
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print(error)
                                    }
                                } catch let networkError as NetworkError {
                                    
                                    switch networkError {
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
                                .foregroundStyle(.black)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15.0)
                        })
                        .background(.orange, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(isEnabled ? 0.7 : 0.2)
                        .padding(.bottom, 10)
                        .alert("Error getting data from server", isPresented: $isAlertPresented) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                } else {
                    ScrollView(.vertical) {
                        Text("Breakfast")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        RecipeMealRowView(recipeData: dailyMenus[currentDay - 1].breakfast)
                        
                        Divider()
                        
                        Text("Lunch")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        RecipeMealRowView(recipeData: dailyMenus[currentDay - 1].lunch)
                        
                        Divider()
                        
                        Text("Snack")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        RecipeMealRowView(recipeData: dailyMenus[currentDay - 1].snack)
                        
                        Divider()
                        
                        Text("Dinner")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        RecipeMealRowView(recipeData: dailyMenus[currentDay - 1].dinner)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    DailyMenuView(currentDay: 1)
        .modelContainer(for: [GoalModel.self, UserModel.self, DailyMenuModel.self, MenuPreferencesModel.self], inMemory: true)
}
