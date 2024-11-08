//
//  DayDetailsView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 2.11.24.
//

import SwiftUI
import SwiftData

struct DayDetailsView: View {
    
    @Query private var goals: [GoalsModel]
    @Query private var users: [UserModel]
    
    let currentDay: Int
    
    var body: some View {
        GeometryReader { geometry in
            if !users.isEmpty && !goals.isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        
                        HStack {
                            Text("initial")
                                .font(.caption)
                                .frame(alignment: .leading)
                            
                            Spacer()
                            
                            Text("current")
                                .font(.caption)
                                .frame(alignment: .center)
                            
                            Spacer()
                            
                            Text("target")
                                .font(.caption)
                                .frame(alignment: .trailing)
                        }
                        .frame(width: ((geometry.size.width - 60) * 0.8), height: 15.0)
                    }
                    
                    ProgressBarView(title: "weight", initialValue: users.first!.weight, targetValue: goals.first!.targetWeight, estimatedDays: goals.first!.estimatedDays, currentDay: currentDay)
                    
                    ProgressBarView(title: "bmi", initialValue: users.first!.currentBmi, targetValue: goals.first!.targetBmi, estimatedDays: goals.first!.estimatedDays, currentDay: currentDay)
                    
                    Text("Daily menu")
                        .bold()
                        .font(.title)
                        .frame(alignment: .center)
                        .padding(.top, 30)
                    
                    DailyMenuView(currentDay: currentDay)
                        .frame(height: geometry.size.height * 0.6, alignment: .bottom)
                }
                .padding(.horizontal, 30)
            } else {
                Text("Setup user and goals first!")
            }
        }
    }
}

#Preview {
    DayDetailsView(currentDay: 1)
}
