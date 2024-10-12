//
//  ContentView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "house")
                        .resizable()
                    Text("Home")
                        .bold(true)
            }
          
            UserView()
                .tag(1)
                .tabItem {
                    Image(systemName: "person.crop.circle.badge")
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
                        .bold()
            }
        }
    }
}

#Preview {
    ContentView()
}
