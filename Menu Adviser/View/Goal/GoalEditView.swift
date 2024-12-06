//
//  GoalsEditView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 20.10.24.
//

import SwiftUI
import SwiftData

struct GoalEditView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var goals: [GoalModel]
    @Query private var users: [UserModel]
    
    @Binding var isEditGoalsActive: Bool
    
    @State private var targetGoal: GoalOptions = .undefined
    @State private var targetActivity: ActivityOptions = .undefined
    @State private var targetWeight: Float = 0
    @State private var targetCalories: Int = 0
    @State private var targetBmi: Float = 0
    @State private var progressPace: PaceOptions = .undefined
    @State private var estimatedDays: Int = 0
    
    @State private var isAlertPresented = false
    
    func isInputDataValid() -> Bool {
        var isValid = false
        
        if targetGoal != .undefined &&
            targetActivity != .undefined &&
            targetWeight > 0 &&
            targetCalories > 0 &&
            targetBmi > 0 &&
            estimatedDays > 0 {
            isValid = true
        }
        
        return isValid
    }
    
    func updateTargetBmi() {
        targetBmi = AppData.shared.calculateBmi(weight: targetWeight, height: users.first!.height)
    }
    
    func updateTargetCalories() {
        
        guard progressPace != .undefined else { return }
        
        switch targetGoal {
        case .weightLoss:
            targetCalories = users.first!.currentDailyCalories - progressPace.caloriesCompensation
        case .stayFit:
            targetCalories = users.first!.currentDailyCalories
        case .gainWeight:
            targetCalories = users.first!.currentDailyCalories + progressPace.caloriesCompensation
            // case for .undefined or .stayFit
        default:
            targetCalories = 0
        }
    }
    
    func updateEstimatedDays() {
        guard targetWeight > 0 && progressPace != .undefined && targetGoal != .undefined else { return }
        
        estimatedDays = AppData.shared.calculateEstimatedDays(weightDifference: Int(targetWeight - users.first!.weight), progressPace: progressPace)
    }
    
    var body: some View {
        VStack {
            if users.isEmpty {
                Text("Goal")
                    .font(.title)
                
                Spacer()
                
                Text("Please set up user data first!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .bold()
                
                Spacer()
            } else {
                Text( goals.isEmpty ? "Add Goal" : "Edit Goal")
                    .font(.title)
                
                Text("Goal")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
                
                Picker("", selection: $targetGoal) {
                    Text(GoalOptions.weightLoss.rawValue).tag(GoalOptions.weightLoss)
                    Text(GoalOptions.stayFit.rawValue).tag(GoalOptions.stayFit)
                    Text(GoalOptions.gainWeight.rawValue).tag(GoalOptions.gainWeight)
                }
                .colorMultiply(.green)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onChange(of: targetGoal) {
                    updateEstimatedDays()
                    updateTargetCalories()
                }
                
                Text("Target Activity")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 15)
                
                Picker("", selection: $targetActivity) {
                    Text(ActivityOptions.low.rawValue).tag(ActivityOptions.low)
                    Text(ActivityOptions.moderate.rawValue).tag(ActivityOptions.moderate)
                    Text(ActivityOptions.high.rawValue).tag(ActivityOptions.high)
                }
                .colorMultiply(.green)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onChange(of: targetGoal) {
                    updateTargetCalories()
                }
                
                HStack {
                    Text("Target Weight (kg.)")
                        .bold()
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    TextField("", value: $targetWeight, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                        .frame(maxWidth: .infinity, minHeight: 30.0)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.2))
                        .onChange(of: targetWeight) {
                            updateTargetBmi()
                            updateTargetCalories()
                            updateEstimatedDays()
                        }
                }
                .padding(.top, 15)
                
                Text("Daily Calories")
                    .padding(.top, 10)
                    .bold()
                
                HStack {
                    Text("Current")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text("\(!users.isEmpty ? users.first!.currentDailyCalories : 0)")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                HStack {
                    Text("Target")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text("\(targetCalories)")
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
                    
                    Text(String(format: "%.2f", targetBmi))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Text("Progress Pace")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 15)
                
                Picker("", selection: $progressPace) {
                    Text(PaceOptions.slow.rawValue).tag(PaceOptions.slow)
                    Text(PaceOptions.normal.rawValue).tag(PaceOptions.normal)
                    Text(PaceOptions.fast.rawValue).tag(PaceOptions.fast)
                }
                .colorMultiply(.green)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onChange(of: progressPace) {
                    updateTargetCalories()
                    updateEstimatedDays()
                }
                
                HStack {
                    Text("Estimated Days")
                        .bold()
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text("\(estimatedDays)")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 15)
                
                Spacer()
                
                Button(action: {
                    if isInputDataValid() {
                        if let goal = goals.first {
                            goal.targetGoal = targetGoal.rawValue
                            goal.targetActivity = targetActivity.rawValue
                            goal.targetWeight = targetWeight
                            goal.targetCalories = targetCalories
                            goal.targetBmi = targetBmi
                            goal.estimatedDays = estimatedDays
                            goal.progressPace = progressPace.rawValue
                        } else {
                            let newGoal = GoalModel(targetGoal: targetGoal.rawValue, targetWeight: targetWeight, targetCalories: targetCalories, targetBmi: targetBmi, estimatedDays: estimatedDays, targetActivity: targetActivity.rawValue, progressPace: progressPace.rawValue)
                            
                            modelContext.insert(newGoal)
                            
                            do {
                                try modelContext.save()
                            } catch {
                                print(error)
                            }
                        }
                        
                        isEditGoalsActive = false
                    } else {
                        isAlertPresented = true
                    }
                }, label: {
                    Text("Save")
                        .foregroundStyle(.black)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15.0)
                })
                .background(.green, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.top, 30)
                .padding(.bottom, 10)
                .alert("Please fill all of the fields", isPresented: $isAlertPresented) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
        .padding(.horizontal, 30)
        .task {
            if let goal = goals.first {
                targetGoal = GoalOptions(rawValue: goal.targetGoal) ?? .undefined
                targetActivity = ActivityOptions(rawValue: goal.targetActivity) ?? .undefined
                targetWeight = goal.targetWeight
                targetCalories = goal.targetCalories
                targetBmi = goal.targetBmi
                estimatedDays = goal.estimatedDays
                progressPace = PaceOptions(rawValue: goal.progressPace) ?? .undefined
            }
        }
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    GoalEditView(isEditGoalsActive: $value)
        .modelContainer(for: [GoalModel.self, UserModel.self], inMemory: true)
}
