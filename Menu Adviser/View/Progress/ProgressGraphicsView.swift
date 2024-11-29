//
//  DayDetailsView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 2.11.24.
//

import SwiftUI
import SwiftData

struct ProgressGraphicsView: View {
    
    @Query private var goals: [GoalModel]
    @Query private var users: [UserModel]
    
    let currentDay: Int
    @State var isEnabled: Bool
    
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
                }
                .padding(.horizontal, 30)
            } else {
                Text("Setup user and goals first!")
            }
        }
    }
}

#Preview {
    ProgressGraphicsView(currentDay: 1, isEnabled: false)
}
