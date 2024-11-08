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
    @Query private var goals: [GoalsModel]
    
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
                    AppData.shared.generateDailyMenu(user: users.first!, goal: goals.first!) { response in
                        if let menu = response {
                            let dailyMenu = DailyMenuModel(
                                id: currentDay,
                                // breakfast, lunch, snack and dinner are confirmed as not nil in AppData
                                breakfast: menu.breakfast!,
                                lunch: menu.lunch!,
                                snack: menu.snack!,
                                dinner: menu.dinner!
                            )
                            
                            modelContext.insert(dailyMenu)
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
        .modelContainer(for: [GoalsModel.self, UserModel.self, DailyMenuModel.self], inMemory: true)
}
