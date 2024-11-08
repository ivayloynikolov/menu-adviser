//
//  HomeView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

struct ProgressView: View {
    
    @Environment(\.selectedRecipe) var selectedRecipe
    
    @Query private var menus: [DailyMenuModel]
    @Query private var goals: [GoalsModel]
    
    @State private var navigationPath = NavigationPath()
    @State private var isRecipeDetailsPresented: Bool = true
    
    @State private var selectedDay: Int = 1
    @State private var scrolledId: Int?
    
    let scrollViewPadding: CGFloat = 20.0
    let spacingBetweenDayBadges: CGFloat = 20.0
    
    func calculateBadgeWidth(screenWidth: CGFloat) -> CGFloat {
        var result = screenWidth - scrollViewPadding * 2
        result -= spacingBetweenDayBadges * 2
        result /= 3
        
        return result
    }
        
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                VStack {
                    Text("Progress")
                        .font(.title)
                    
                    if goals.isEmpty {
                        Text("You must set goals first to be able to see the progress!")
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                    } else {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: spacingBetweenDayBadges) {
                                ForEach(0..<goals.first!.estimatedDays, id: \.self) { index in
                                    DayBadgeView(frameWidth: calculateBadgeWidth(screenWidth: geometry.size.width), dayId: index + 1, isSelected: index + 1 == selectedDay)
                                        .id(index + 1)
                                        .onTapGesture {
                                            selectedDay = index + 1
                                        }
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .padding(.horizontal, scrollViewPadding)
                        .frame(maxHeight: 180, alignment: .top)
                        .scrollPosition(id: $scrolledId)
                        .onScrollPhaseChange { oldPhase, newPhase in
                            if newPhase == .idle, let selectedId = scrolledId {
                                selectedDay = selectedId
                            }
                        }
                        
                        DayDetailsView(currentDay: selectedDay)
                            .padding(.top, 20)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationDestination(isPresented: selectedRecipe.isRecipeSelected) {
                    VStack {
                        RecipeDetailsView()
                    }
                }
            }
        }
    }
}

#Preview {
    ProgressView()
        .modelContainer(for: DailyMenuModel.self, inMemory: true)
}
