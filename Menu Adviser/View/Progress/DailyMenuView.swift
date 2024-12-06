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
    @State private var isEditAlertPresented: Bool = false
    @State private var isNetworkAlertPresented: Bool = false
    @State private var appDataError: AppDataError?
    @State private var networkError: NetworkError?
    
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
                .padding(.top, 10)
            
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
                                    
                                    let dailyMenu = DailyMenuModel(
                                        id: currentDay,
                                        breakfast: recipeDailyMenuData.breakfast,
                                        lunch: recipeDailyMenuData.lunch,
                                        snack: recipeDailyMenuData.snack,
                                        dinner: recipeDailyMenuData.dinner,
                                        calculatedDailyCalories: AppData.shared.calculateDefaultDailyCalories(goals: goals, dailyMenus: dailyMenus)
                                    )
                                    
                                    isGeneratingInProgress = false
                                    
                                    modelContext.insert(dailyMenu)
                                    
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        appDataError = .unsuccessfulSave
                                        isEditAlertPresented = true
                                    }
                                } catch let error as NetworkError {
                                    networkError = error
                                    isNetworkAlertPresented = true
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
        .alert(Text(appDataError?.failureReason ?? ""), isPresented: $isEditAlertPresented) {
            Button("Ok", role: .cancel) {
                isEditAlertPresented = false
            }
        } message: {
            Text("\n\(appDataError?.recoverySuggestion ?? "") \n\n\(appDataError?.errorDescription ?? "")")
        }
        .alert(Text(networkError?.failureReason ?? ""), isPresented: $isNetworkAlertPresented) {
            Button("Ok", role: .cancel) {
                isNetworkAlertPresented = false
            }
        } message: {
            Text("\n\(networkError?.recoverySuggestion ?? "") \n\n\(networkError?.errorDescription ?? "")")
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    DailyMenuView(currentDay: 1)
        .modelContainer(for: [GoalModel.self, UserModel.self, DailyMenuModel.self, MenuPreferencesModel.self], inMemory: true)
}
