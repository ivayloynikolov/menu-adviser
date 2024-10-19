//
//  UserView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

enum SexOptions: String {
    case male, female, undefined
}

enum ActivityOptions: String {
    case low, moderate, high, undefined
}

struct UserDataView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var users: [UserModel]
    
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var sex: SexOptions = .undefined
    @State private var weight: Float = 0
    @State private var height: Int = 0
    @State private var activity: ActivityOptions = .undefined
    @State private var currentBmi: Float = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("User data")
                    .font(.title)
            
                HStack {
                    Text("Name")
                        .frame(width: geometry.size.width * 0.4, alignment: .leading)
                    
                    TextField("", text: $name)
                    .autocorrectionDisabled()
                    .frame(maxWidth: .infinity, minHeight: 30.0)
                    .padding(.horizontal, 5)
                    .background(Color.gray.opacity(0.2))
                }
                .padding(.top, 20)
                
                HStack {
                    Text("Age")
                        .frame(width: geometry.size.width * 0.4, alignment: .leading)
                    
                    TextField("", value: $age, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                        .frame(maxWidth: .infinity, minHeight: 30.0)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.2))
                }
                
                Text("Sex")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                Picker("", selection: $sex) {
                    Text("male").tag(SexOptions.male)
                    Text("female").tag(SexOptions.female)
                }
                .colorMultiply(.green)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Text("Weight (kg.)")
                        .frame(width: geometry.size.width * 0.4, alignment: .leading)
                    
                    TextField("", value: $weight, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                        .frame(maxWidth: .infinity, minHeight: 30.0)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.2))
                }
                .padding(.top, 20)
                
                HStack {
                    Text("Height (cm.)")
                        .frame(width: geometry.size.width * 0.4, alignment: .leading)
                    
                    TextField("", value: $height, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                        .frame(maxWidth: .infinity, minHeight: 30.0)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.2))
                }
                
                Text("Activity")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                
                Picker("", selection: $activity) {
                    Text("low").tag(ActivityOptions.low)
                    Text("moderate").tag(ActivityOptions.moderate)
                    Text("high").tag(ActivityOptions.high)
                }
                .colorMultiply(.green)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Text("Current BMI")
                        .frame(width: geometry.size.width * 0.4, alignment: .leading)
                    
                    Text(String(format: "%.2f", currentBmi))
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 40)
                
                Button(action: {
                    if users.count > 0 {
                        let user = UserModel(name: name, age: age, sex: sex.rawValue, weight: weight, height: height, activity: activity.rawValue, bmi: currentBmi)
                        
                        modelContext.insert(user)
                    } else {
                        users[0].name = name
                        users[0].age = age
                        users[0].sex = sex.rawValue
                        users[0].weight = weight
                        users[0].height = height
                        users[0].activity = activity.rawValue
                        users[0].bmi = currentBmi
                    }
                }, label: {
                    Text("Save")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20.0)
                })
                .background(.red, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.top, 30)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 30)
        .task {
            if users.count > 0 {
                name = users[0].name
                age = users[0].age
                sex = SexOptions(rawValue: users[0].sex)!
                weight = users[0].weight
                height = users[0].height
                activity = ActivityOptions(rawValue: users[0].activity)!
                currentBmi = users[0].bmi
            }
        }
    }
}

#Preview {
    UserDataView()
        .modelContainer(for: UserModel.self, inMemory: true)
}
