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
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("User data")
                    .font(.title)
                
                if users.count > 0 {
                    Text(users.first!.name)
                        .bold()
                        .font(.title)
                        .padding(.top, 20)
                
                    Text("(\(users.first!.age) years)")
                        .font(.footnote)
                    
                    HStack {
                        Text("Sex")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
                        Text(users.first!.sex)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.top, 10)
                    
                    HStack {
                        Text("Weight (kg.)")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
                        Text(String(format: "%.2f", users.first!.weight))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.top, 5)
                    
                    HStack {
                        Text("Height (cm.)")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
                        Text("\(users.first!.height)")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.top, 5)
                    
                    HStack {
                        Text("Activity")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
                        Text(users.first!.activity)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.top, 5)
                    
                    HStack {
                        Text("Current BMI")
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        
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
                        do {
                            try modelContext.delete(model: UserModel.self)
                            try modelContext.save()
                        } catch {
                            print(error)
                        }
                    }, label: {
                        Text("Delete User")
                            .foregroundStyle(.black)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15.0)
                    })
                    .background(.red, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                    .padding(.bottom, 10)
                } else {
                    Text("Please add user data")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        isEditUserActive = true
                    }, label: {
                        Text("Add User")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15.0)
                    })
                    .background(.green, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    UserDataView(isEditUserActive: $value)
        .modelContainer(for: UserModel.self, inMemory: true)
}
