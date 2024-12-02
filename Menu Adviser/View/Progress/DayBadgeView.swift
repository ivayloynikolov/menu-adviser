//
//  DayBadgeView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 1.11.24.
//

import SwiftUI
import SwiftData

struct DayBadgeView: View {
    
    @Query private var dailyMenus: [DailyMenuModel]
    @Query private var goals: [GoalModel]
    
    let frameWidth: CGFloat
    let currentDay: Int
    let isSelected: Bool
    
    var hasGeneratedMenu: Bool {
        return dailyMenus.count > currentDay - 1
    }
    
    var isEnabled: Bool {
        return dailyMenus.count == currentDay - 1
    }
    
    var isLocked: Bool {
        return dailyMenus.count < currentDay - 1
    }
    
    var caloriesDiference: Int {
        if goals.first != nil, hasGeneratedMenu {
            return dailyMenus[currentDay - 1].calculatedDailyCalories - dailyMenus[currentDay - 1].menuCalories
        } else {
            return 0
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? .green.opacity(0.3) : isEnabled ? .orange.opacity(0.3) : .gray.opacity(0.3))
                .scaledToFill()
                .frame(width: frameWidth)
                .aspectRatio(1 / 1.5, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
            
            VStack {
                Text("DAY")
                    .bold()
                    .font(.largeTitle)
                
                Text("\(currentDay)")
                    .bold()
                    .font(.largeTitle)
                
                Text("\(hasGeneratedMenu ? dailyMenus[currentDay - 1].calculatedDailyCalories : AppData.shared.calculateDefaultDailyCalories(goals: goals, dailyMenus: dailyMenus)) cal.")
                
                if caloriesDiference != 0 {
                    Text("(\(caloriesDiference > 0 ? "-" : "+")\(abs(caloriesDiference)))")
                        .foregroundColor(caloriesDiference > 0 ? .init(red: 0.0, green: 0.4, blue: 0.2) : .red)
                        .bold()
                        .font(.caption)
                } else {
                    Text("(-)")
                        .bold()
                        .font(.caption)
                }
            }
        }
        .opacity(isLocked ? 0.3 : 1)
    }
}

#Preview {
    DayBadgeView(frameWidth: 100, currentDay: 1, isSelected: false)
        .modelContainer(for: [GoalModel.self, DailyMenuModel.self], inMemory: true)
}
