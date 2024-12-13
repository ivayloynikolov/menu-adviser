//
//  Menu_AdviserApp.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

@main
struct Menu_AdviserApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [UserModel.self, GoalModel.self, DailyMenuModel.self, MenuPreferencesModel.self])
        }
    }
}
