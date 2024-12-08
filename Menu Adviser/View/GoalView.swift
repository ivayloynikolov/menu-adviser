//
//  GoalsView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

struct GoalView: View {
    @Query var goals: [GoalModel]
    
    @State var isEditGoalsActive: Bool = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        if goals.isEmpty {
            GoalEditView(isEditGoalsActive: $isEditGoalsActive)
        } else {
            NavigationStack(path: $navigationPath) {
                VStack {
                    GoalDataView(isEditGoalsActive: $isEditGoalsActive)
                }
                .navigationDestination(isPresented: $isEditGoalsActive) {
                    VStack {
                        GoalEditView(isEditGoalsActive: $isEditGoalsActive)
                    }
                }
            }
        }
    }
}


#Preview {
    GoalView()
}
