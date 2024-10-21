//
//  GoalsDataView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 20.10.24.
//

import SwiftUI
import SwiftData

struct GoalsDataView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var goals: [GoalsModel]
    
    @Binding var isEditGoalsActive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Goals")
                    .font(.title)
                
                if goals.count > 0 {
                    HStack {
                        Text("Goal")
                            .frame(maxWidth: geometry.size.width * 0.5, alignment: .leading)
                            .padding(.top, 20)
                        
                        Text(goals[0].goal)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.top, 20)
                    
                    HStack {
                        Text("Target Weight (kg.)")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
                        Text(String(format: "%.2f", goals[0].targetWeight))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.top, 5)
                    
                    HStack {
                        Text("Target Calories")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
                        Text("\(goals[0].targetCalories)")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 40)
                    
                    HStack {
                        Text("Target BMI")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
                        Text(String(format: "%.2f", goals[0].targetBMI))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 5)
                    
                    HStack {
                        Text("Estimated Days")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
                        Text(String(format: "%.2f", goals[0].estimatedDays))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 5)
                    
                    Spacer()
                    
                    Button(action: {
                        isEditGoalsActive = true
                    }, label: {
                        Text("Edit Goals")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20.0)
                    })
                    .background(.orange, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                    .padding(.top, 30)
                    .padding(.bottom, 5)
                    
                    Button(action: {
                        do {
                            try modelContext.delete(model: GoalsModel.self)
                            try modelContext.save()
                        } catch {
                            print(error)
                        }
                    }, label: {
                        Text("Delete Goals")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20.0)
                    })
                    .background(.red, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                } else {
                    Text("Please add goals data")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        isEditGoalsActive = true
                    }, label: {
                        Text("Add Goals")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20.0)
                    })
                    .background(.green, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                }
            }
            .padding(.top, 20)
//            .frame(maxHeight: .infinity, alignment: .top)
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    GoalsDataView(isEditGoalsActive: $value)
        .modelContainer(for: GoalsModel.self, inMemory: true)
}
