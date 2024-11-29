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
    let dayId: Int
    let isSelected: Bool
    
    var isEnabled: Bool {
        return dailyMenus.count == dayId - 1
    }
    
    var isLocked: Bool {
        return dailyMenus.count < dayId - 1
    }
    
    var caloriesDiference: Int {
        if let goal = goals.first, dailyMenus.count >= dayId {
            return goal.targetCalories - dailyMenus[dayId - 1].menuCalories
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
                
                Text("\(dayId)")
                    .bold()
                    .font(.largeTitle)
                
                Text("\(goals.first != nil ? goals.first!.targetCalories : 0) cal.")
                
                if caloriesDiference != 0 {
                    Text("(\(caloriesDiference > 0 ? "+" : "")\(caloriesDiference))")
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
    DayBadgeView(frameWidth: 100, dayId: 1, isSelected: false)
        .modelContainer(for: [GoalModel.self, DailyMenuModel.self], inMemory: true)
}
