//
//  GoalsDataView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 20.10.24.
//

import SwiftUI
import SwiftData

struct GoalDataView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var goals: [GoalModel]
    @Query var users: [UserModel]
    
    @Binding var isEditGoalsActive: Bool
    
    var body: some View {
        VStack {
            Text("Goal")
                .font(.title)
            
            if goals.isEmpty {
                Text("Please add goals data")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    isEditGoalsActive = true
                }, label: {
                    Text("Add Goals")
                        .foregroundStyle(.black)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20.0)
                })
                .background(.green, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.top, 30)
                .padding(.bottom, 20)
            } else {
                HStack {
                    Text(goals.first!.targetGoal)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.title)
                }
                .padding(.top, 5)
                
                Text("Weight (kg.)")
                    .padding(.top, 10)
                    .bold()
                
                HStack {
                    Text("Current")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(String(format: "%.2f", users.first!.weight))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                HStack {
                    Text("Target")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(String(format: "%.2f", goals.first!.targetWeight))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Text("Daily Calories")
                    .padding(.top, 10)
                    .bold()
                
                HStack {
                    Text("Current")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text("\(users.first!.currentDailyCalories)")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                HStack {
                    Text("Target")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text("\(goals.first!.targetCalories)")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Text("BMI")
                    .padding(.top, 10)
                    .bold()
                
                HStack {
                    Text("Current")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(String(format: "%.2f", users.first!.currentBmi))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                HStack {
                    Text("Target")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(String(format: "%.2f", goals.first!.targetBmi))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Text("Physical Activity")
                    .padding(.top, 10)
                    .bold()
                
                HStack {
                    Text("Current")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(users.first!.activity)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                HStack {
                    Text("Target")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(goals.first!.targetActivity)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Text("Estimated Goals Achievement Days")
                    .bold()
                    .padding(.top, 40)
                
                Text("\(goals.first!.estimatedDays)")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.green)
                    .padding(.top, 5)
                
                Spacer()
                
                Button(action: {
                    isEditGoalsActive = true
                }, label: {
                    Text("Edit Goals")
                        .foregroundStyle(.black)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15.0)
                })
                .background(.orange, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.top, 30)
                
                Button(action: {
                    do {
                        try modelContext.delete(model: GoalModel.self)
                        try modelContext.delete(model: DailyMenuModel.self)
                        try modelContext.save()
                    } catch {
                        print(error)
                    }
                }, label: {
                    Text("Delete Goals")
                        .foregroundStyle(.black)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15.0)
                })
                .background(.red, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.bottom, 10)
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    GoalDataView(isEditGoalsActive: $value)
        .modelContainer(for: [GoalModel.self, UserModel.self], inMemory: true)
}
