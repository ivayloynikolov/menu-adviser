//
//  MenuView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

struct MenuView: View {
    @Query var dishes: [DishModel]
    
    @State var isMenuGenerated: Bool = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                SelectFoodView(isMenuGenerated: $isMenuGenerated)
            }
            .navigationDestination(isPresented: $isMenuGenerated) {
                VStack {
                    GeneratedMenuView(isMenuGenerated: $isMenuGenerated)
                }
            }
        }
        .task {
            isMenuGenerated = dishes.count > 0
        }
    }
}

#Preview {
    MenuView()
}
