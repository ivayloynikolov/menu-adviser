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
    @State private var appDataError: AppDataError?
    
    func isInputDataValid() -> Bool {
        var isValid = false
        
        if name != "" &&
            age > 15 &&
            age < 100 &&
            sex != SexOptions.undefined &&
            weight > 30 &&
            weight < 250 &&
            height > 100 &&
            height < 230 &&
            activity != ActivityOptions.undefined &&
            currentBmi > 0 {
            isValid = true
        }
        
        return isValid
    }
    
    var body: some View {
        VStack {
            Text(users.isEmpty ? "Add User Data" : "Edit User Data")
                .font(.title)
            
            Spacer()
            
            HStack {
                Text("Name")
                    .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                
                TextField("", text: $name)
                    .autocorrectionDisabled()
                    .frame(maxWidth: .infinity, minHeight: 30.0)
                    .padding(.horizontal, 5)
                    .background(Color.gray.opacity(0.2))
            }
            .padding(.top, 20)
            
            HStack {
                Text("Age")
                    .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                
                TextField("", value: $age, formatter: NumberFormatter())
                    .keyboardType(.numbersAndPunctuation)
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
                    .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                
                TextField("", value: $weight, formatter: NumberFormatter())
                    .keyboardType(.numbersAndPunctuation)
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
                    .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                
                TextField("", value: $height, formatter: NumberFormatter())
                    .keyboardType(.numbersAndPunctuation)
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
                    .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                
                Text(String(format: "%.2f", currentBmi))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(currentBmi == 0 ? .red : .primary)
            }
            .padding(.top, 40)
            
            Spacer()
            
            Button(action: {
                if isInputDataValid()  {
                    appDataError = nil
                    
                    if let user = users.first {
                        user.name = name
                        user.age = age
                        user.sex = sex.rawValue
                        user.weight = weight
                        user.height = height
                        user.activity = activity.rawValue
                    } else {
                        let newUser = UserModel(
                            name: name,
                            age: age,
                            sex: sex.rawValue,
                            weight: weight,
                            height: height,
                            activity: activity.rawValue
                        )
                        
                        modelContext.insert(newUser)
                    }
                    
                    do {
                        try modelContext.save()
                        appDataError = nil
                        isEditUserActive = false
                    } catch {
                        appDataError = .unsuccessfulSave
                        isAlertPresented = true
                    }
                } else {
                    appDataError = .invalidInput
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
            .alert(Text(appDataError?.failureReason ?? ""), isPresented: $isAlertPresented) {
                Button("Ok", role: .cancel) {
                    isAlertPresented = false
                }
            } message: {
                Text("\n\(appDataError?.recoverySuggestion ?? "") \n\n\(appDataError?.errorDescription ?? "")")
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
        .task {
            if !users.isEmpty {
                name = users.first!.name
                age = users.first!.age
                sex = SexOptions(rawValue: users.first!.sex) ?? .undefined
                weight = users.first!.weight
                height = users.first!.height
                activity = ActivityOptions(rawValue: users.first!.activity) ?? .undefined
                currentBmi = users.first!.currentBmi
            }
        }
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    UserEditView(isEditUserActive: $value)
        .modelContainer(for: UserModel.self, inMemory: true)
}
