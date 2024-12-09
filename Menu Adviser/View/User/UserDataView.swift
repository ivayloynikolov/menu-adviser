//
//  UserView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

struct UserDataView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var users: [UserModel]
    
    @Binding var isEditUserActive: Bool
    
    @State private var isEditAlertPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var appDataError: AppDataError?
    
    var body: some View {
        VStack {
            if !users.isEmpty {
                Text("User data")
                    .font(.title)
                
                Text(users.first!.name)
                    .bold()
                    .font(.title)
                    .padding(.top, 20)
                
                Text("(\(users.first!.age) years)")
                    .font(.footnote)
                
                HStack {
                    Text("Sex")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(users.first!.sex)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 10)
                
                HStack {
                    Text("Weight (kg.)")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(String(format: "%.2f", users.first!.weight))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 5)
                
                HStack {
                    Text("Height (cm.)")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text("\(users.first!.height)")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 5)
                
                HStack {
                    Text("Activity")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(users.first!.activity)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 5)
                
                HStack {
                    Text("Current BMI")
                        .frame(width: UIScreen.main.bounds.width * 0.5, alignment: .leading)
                    
                    Text(String(format: "%.2f", users.first!.currentBmi))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 5)
                
                Spacer()
                
                Button(action: {
                    isEditUserActive = true
                }, label: {
                    Text("Edit User")
                        .foregroundStyle(.black)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15.0)
                })
                .background(.orange, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.top, 30)
                
                Button(action: {
                    appDataError = .deleteUserWarning
                    isDeleteAlertPresented = true
                }, label: {
                    Text("Delete User")
                        .foregroundStyle(.black)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15.0)
                })
                .background(.red, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                .padding(.bottom, 10)
            }
        }
        .alert(Text(appDataError?.failureReason ?? ""), isPresented: $isEditAlertPresented) {
            Button("Ok", role: .cancel) {
                isEditAlertPresented = false
            }
        } message: {
            Text("\n\(appDataError?.recoverySuggestion ?? "") \n\n\(appDataError?.errorDescription ?? "")")
        }
        .alert(Text(appDataError?.failureReason ?? ""), isPresented: $isDeleteAlertPresented) {
            Button("Cancel", role: .cancel) {
                isDeleteAlertPresented = false
            }
            
            Button("Delete", role: .destructive) {
                do {
                    try modelContext.delete(model: UserModel.self)
                    try modelContext.delete(model: GoalModel.self)
                    try modelContext.delete(model: MenuPreferencesModel.self)
                    try modelContext.delete(model: DailyMenuModel.self)
                    try modelContext.save()
                    
                    appDataError = nil
                    isDeleteAlertPresented = false
                } catch {
                    appDataError = .unsuccessfulDelete
                    isDeleteAlertPresented = false
                    isEditAlertPresented = true
                }
            }
        } message: {
            Text("\n\(appDataError?.recoverySuggestion ?? "") \n\n\(appDataError?.errorDescription ?? "")")
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    UserDataView(isEditUserActive: $value)
        .modelContainer(for: UserModel.self, inMemory: true)
}
