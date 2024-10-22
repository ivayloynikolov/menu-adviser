//
//  GoalsEditView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 20.10.24.
//

import SwiftUI
import SwiftData

enum GoalOptions: String {
    case weightLoss = "weight loss"
    case stayFit = "stay fit"
    case gainMuscle = "gain muscle"
    case undefined = "undefined"
}

struct GoalsEditView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var goals: [GoalsModel]
    
    @Binding var isEditGoalsActive: Bool
    
    @State private var goal: GoalOptions = .undefined
    @State private var targetActivity: ActivityOptions = .undefined
    @State private var targetWeight: Float = 0
    @State private var targetCalories: Int = 0
    @State private var targetBMI: Float = 0
    @State private var estimatedDays: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text( goals.count > 0 ? "Edit Goals" : "Add Goals")
                    .font(.title)
                
                Text("Goal")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                
                Picker("", selection: $goal) {
                    Text(GoalOptions.weightLoss.rawValue).tag(GoalOptions.weightLoss)
                    Text(GoalOptions.stayFit.rawValue).tag(GoalOptions.stayFit)
                    Text(GoalOptions.gainMuscle.rawValue).tag(GoalOptions.gainMuscle)
                }
                .colorMultiply(.green)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Text("Target Weight (kg.)")
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
                    TextField("", value: $targetWeight, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                        .frame(maxWidth: .infinity, minHeight: 30.0)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.2))
                }
                .padding(.top, 20)
                
                HStack {
                    Text("Target Calories")
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
                    Text("\(targetCalories)")
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 40)
                
                HStack {
                    Text("Target BMI")
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
                    Text(String(format: "%.2f", targetBMI))
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 5)
                
                HStack {
                    Text("Estimated Days")
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
                    Text(String(format: "%.2f", estimatedDays))
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 5)
                
                Spacer()
                
                Button(action: {
                    // TODO: check if all properties are valid
                    if goals.count > 0 {
                        goals[0].goal = goal.rawValue
                        goals[0].targetActivity = targetActivity.rawValue
                        goals[0].targetWeight = targetWeight
                        goals[0].targetCalories = targetCalories
                        goals[0].targetBMI = targetBMI
                        goals[0].estimatedDays = estimatedDays
                    } else {
                        let goal = GoalsModel(goal: goal.rawValue, targetWeight: targetWeight, targetCalories: targetCalories, targetBMI: targetBMI, estimatedDays: estimatedDays, targetActivity: targetActivity.rawValue)
                        
                        modelContext.insert(goal)
                    }
                    
                    isEditGoalsActive = false
                }, label: {
                    Text("Save")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20.0)
                })
                .background(.green, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.top, 30)
                .padding(.bottom, 20)
            }
            .padding(.top, 10)
//            .frame(maxHeight: .infinity, alignment: .top)
        }
        .padding(.horizontal, 30)
        .task {
            if goals.count > 0 {
                goal = GoalOptions(rawValue: goals[0].goal) ?? .undefined
                targetActivity = ActivityOptions(rawValue: goals[0].targetActivity) ?? .undefined
                targetWeight = goals[0].targetWeight
                targetCalories = goals[0].targetCalories
                targetBMI = goals[0].targetBMI
                estimatedDays = goals[0].estimatedDays
            }
        }
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    GoalsEditView(isEditGoalsActive: $value)
        .modelContainer(for: GoalsModel.self, inMemory: true)
}
