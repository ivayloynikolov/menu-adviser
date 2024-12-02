//
//  ContentView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("selectedTab") private var selectedTab = 0
    
    @State private var selectedRecipe = SelectedRecipe()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            UserView()
                .tag(0)
                .tabItem {
                    Image(systemName: "person.crop.square")
                        .resizable()
                    Text("User")
                }
            
            GoalView()
                .tag(1)
                .tabItem {
                    Image(systemName: "pencil.and.list.clipboard.rtl")
                        .resizable()
                    Text("Goals")
                }
            
            MenuView()
                .tag(2)
                .tabItem {
                    Image(systemName: "fork.knife")
                        .resizable()
                    Text("Menu")
                }
            
            ProgressDaysView()
                .environment(\.selectedRecipe, selectedRecipe)
                .tag(3)
                .tabItem {
                    Image(systemName: "trophy.fill")
                        .resizable()
                    Text("Home")
                }
        }
    }
}

#Preview {
    ContentView()
}

extension EnvironmentValues {
    @Entry var selectedRecipe: SelectedRecipe = SelectedRecipe()
}
