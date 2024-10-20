//
//  HomeView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

struct ProgressView: View {
    @Query var users: [UserModel]
    
    @State private var username: String = "Ivaylo"
    @State private var age: Int = 49
    @State private var sex: String = "male"
    @State private var weight: Float = 78.00
    @State private var height: Int = 175
    @State private var activity: String = "moderate"
    @State private var currentBmi: Float = 0.0
    
    @State private var goal: String = "Stay Fit"
    @State private var targetWeight: Float = 74.00
    @State private var targetCalories: Int = 2100
    @State private var targetBMI: Float = 18.00
    
    var body: some View {
        VStack {
            Text("Personal Data")
                .font(.title)
        
            Text(users.count > 0 ? users[0].name : "no name")
                .padding(.top, 20)
                .fontWeight(.bold)
            
            Text("\(age) years")
        
            Text(sex)
                .padding(.top, 5)
            
            Text("Weight \(String(format: "%.2f", weight)) kg.")
                .padding(.top, 5)
            
            Text("Height \(height) cm.")
                .padding(.top, 5)
            
            Text("Activity \(activity)")
                .padding(.top, 5)
            
            Text("Current BMI \(String(format: "%.2f", currentBmi))")
                .padding(.top, 5)
            
            Text("Goals")
                .font(.title)
                .padding(.top, 40)
            
            Text("Goal \(goal)")
                .padding(.top, 15)
            
            Text("Target Weight \(String(format: "%.2f", targetWeight)) kg.")
                .padding(.top, 5)
            
            Text("Target Calories \(targetCalories)")
                .padding(.top, 5)
            
            Text("Target BMI \(String(format: "%.2f", targetBMI))")
                .padding(.top, 5)
        }
        .padding(.top, 20)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: UserModel.self, inMemory: true)
}
