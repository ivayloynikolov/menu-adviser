//
//  UserView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 19.10.24.
//

import SwiftUI
import SwiftData

struct UserView: View {
    @Query var users: [UserModel]
    
    @State var isEditUserActive: Bool = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                UserDataView(isEditUserActive: $isEditUserActive)
            }
            .navigationDestination(isPresented: $isEditUserActive) {
                VStack {
                    UserEditView(isEditUserActive: $isEditUserActive)
                }
            }
        }
        .task {
            isEditUserActive = users.count == 0
        }
    }
}

#Preview {
    UserView()
}
