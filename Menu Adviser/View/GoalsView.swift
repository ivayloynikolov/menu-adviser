//
//  GoalsView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

struct GoalsView: View {
    @Query var goals: [GoalsModel]
    
    @State var isEditGoalsActive: Bool = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                GoalsDataView(isEditGoalsActive: $isEditGoalsActive)
            }
            .navigationDestination(isPresented: $isEditGoalsActive) {
                VStack {
                    GoalsEditView(isEditGoalsActive: $isEditGoalsActive)
                }
            }
        }
        .task {
            isEditGoalsActive = goals.count == 0
        }
    }
}


#Preview {
    GoalsView()
}
