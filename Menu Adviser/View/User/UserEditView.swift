//
//  UserEditView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 19.10.24.
//

import SwiftUI
import SwiftData

enum SexOptions: String {
    case male, female, undefined
}

enum ActivityOptions: String {
    case low, moderate, high, undefined
}

struct UserEditView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var users: [UserModel]
    
    @Binding var isEditUserActive: Bool
    
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
                Text(users.count > 0 ? "Edit User Data" : "Add User Data")
                    .font(.title)
            
                HStack {
                    Text("Name")
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
                    TextField("", text: $name)
                    .autocorrectionDisabled()
                    .frame(maxWidth: .infinity, minHeight: 30.0)
                    .padding(.horizontal, 5)
                    .background(Color.gray.opacity(0.2))
                }
                .padding(.top, 20)
                
                HStack {
                    Text("Age")
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
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
                    Text(SexOptions.male.rawValue).tag(SexOptions.male)
                    Text(SexOptions.female.rawValue).tag(SexOptions.female)
                }
                .colorMultiply(.green)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Text("Weight (kg.)")
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
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
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
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
                    Text(ActivityOptions.low.rawValue).tag(ActivityOptions.low)
                    Text(ActivityOptions.moderate.rawValue).tag(ActivityOptions.moderate)
                    Text(ActivityOptions.high.rawValue).tag(ActivityOptions.high)
                }
                .colorMultiply(.green)
                .pickerStyle(.segmented)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Text("Current BMI")
                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                    
                    // TODO: calculate BMI using the rest of the data
                    Text(String(format: "%.2f", currentBmi))
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 40)
                
                Spacer()
                
                Button(action: {
                    // TODO: check if all properties are valid
                    if users.count > 0 {
                        users[0].name = name
                        users[0].age = age
                        users[0].sex = sex.rawValue
                        users[0].weight = weight
                        users[0].height = height
                        users[0].activity = activity.rawValue
                        users[0].bmi = currentBmi
                    } else {
                        let user = UserModel(name: name, age: age, sex: sex.rawValue, weight: weight, height: height, activity: activity.rawValue, bmi: currentBmi)
                        
                        modelContext.insert(user)
                    }
                    
                    isEditUserActive = false
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
        }
        .padding(.horizontal, 30)
        .task {
            if users.count > 0 {
                name = users[0].name
                age = users[0].age
                sex = SexOptions(rawValue: users[0].sex) ?? .undefined
                weight = users[0].weight
                height = users[0].height
                activity = ActivityOptions(rawValue: users[0].activity) ?? .undefined
                currentBmi = users[0].bmi
            }
        }
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    UserEditView(isEditUserActive: $value)
        .modelContainer(for: UserModel.self, inMemory: true)
}
