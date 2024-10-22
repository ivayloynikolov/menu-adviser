//
//  ContentView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @AppStorage("selectedTab") private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            UserView()
                .tag(1)
                .tabItem {
                    Image(systemName: "person.crop.square")
                        .resizable()
                    Text("User")
            }
            
            GoalsView()
                .tag(2)
                .tabItem {
                    Image(systemName: "pencil.and.list.clipboard.rtl")
                        .resizable()
                    Text("Goals")
            }
        
            MenuView()
                .tag(3)
                .tabItem {
                    Image(systemName: "fork.knife")
                        .resizable()
                    Text("Menu")
            }
            
            ProgressView()
                .tag(0)
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
        .modelContainer(for: UserModel.self, inMemory: true)
}
