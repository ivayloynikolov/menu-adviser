//
//  UserEditView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 19.10.24.
//

import SwiftUI
import SwiftData



struct UserEditView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var users: [UserModel]
    
    @Binding var isEditUserActive: Bool
    
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var sex: SexOptions = .undefined
    @State private var weight: Float = 0
    @State private var height: Int = 0
    @State private var activity: ActivityOptions = .undefined
    @State private var currentBmi: Float = 0.0
    
    @State private var isAlertPresented = false
    @State private var isOnboardingPresented = true
    
    func isInputDataValid() -> Bool {
        var isValid = false
        
        if name != "" &&
            age > 0 &&
            sex != SexOptions.undefined &&
            weight > 0 &&
            height > 0 &&
            activity != ActivityOptions.undefined &&
            currentBmi > 0 {
            isValid = true
        }
        
        return isValid
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(users.count > 0 ? "Edit User Data" : "Add User Data")
                    .font(.title)
                
                Spacer()
                
                if !isOnboardingPresented {
                    Text("First you need to enter your data. Then your goals and menu preferences. Then you will be able to generate daily menus according to your goals and preferences and track your goal status.")
                        .multilineTextAlignment(.center)
                    
                    Button {
                        isOnboardingPresented = true
                    } label: {
                        Text("Great. Lets do it!")
                    }
                    .padding(.top, 30)

                    Spacer()
                } else {
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
                            .onChange(of: weight) {
                                currentBmi = AppData.shared.calculateBmi(weight: weight, height: height)
                            }
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
                            .onChange(of: height) {
                                currentBmi = AppData.shared.calculateBmi(weight: weight, height: height)
                            }
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
                        
                        Text(String(format: "%.2f", currentBmi))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundStyle(currentBmi == 0 ? .red : .primary)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    Button(action: {
                        if isInputDataValid()  {
                            if let user = users.first {
                                user.name = name
                                user.age = age
                                user.sex = sex.rawValue
                                user.weight = weight
                                user.height = height
                                user.activity = activity.rawValue
                            } else {
                                let newUser = UserModel(name: name, age: age, sex: sex.rawValue, weight: weight, height: height, activity: activity.rawValue)

                                modelContext.insert(newUser)
                            }
                            
                            do {
                                try modelContext.save()
                            } catch {
                                print(error)
                            }
                            
                            isEditUserActive = false
                        } else {
                            isAlertPresented = true
                        }
                    }, label: {
                        Text("Save")
                            .foregroundStyle(.black)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20.0)
                    })
                    .background(.green, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .alert("Please fill all of the fields", isPresented: $isAlertPresented) {
                                Button("OK", role: .cancel) { }
                            }
                }
                
                }
            .padding(.top, 10)
                
        }
        .padding(.horizontal, 30)
        .task {
            if users.count > 0 {
                name = users.first!.name
                age = users.first!.age
                sex = SexOptions(rawValue: users.first!.sex) ?? .undefined
                weight = users.first!.weight
                height = users.first!.height
                activity = ActivityOptions(rawValue: users.first!.activity) ?? .undefined
                currentBmi = users.first!.currentBmi
            } else {
                isOnboardingPresented = false
            }
        }
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    UserEditView(isEditUserActive: $value)
        .modelContainer(for: UserModel.self, inMemory: true)
}
