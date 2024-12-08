//
//  HomeView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI
import SwiftData

struct ProgressDaysView: View {
    
    @Environment(\.selectedRecipe) var selectedRecipe
    @Environment(\.networkMonitor) var networkMonitor
    
    @Query private var menus: [DailyMenuModel]
    @Query private var goals: [GoalModel]
    
    @State private var navigationPath = NavigationPath()
    @State private var isRecipeDetailsPresented: Bool = true
    
    @State private var selectedDay: Int = 1
    @State private var scrolledId: Int?
    
    @State private var isAlertPresented = false
    @State private var networkError: NetworkError?
    
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
            VStack {
                Text("Progress")
                    .font(.title)
                
                if goals.isEmpty {
                    Text("Please set up your goal first!")
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                } else {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: spacingBetweenDayBadges) {
                            ForEach(0..<goals.first!.estimatedDays, id: \.self) { index in
                                DayBadgeView(
                                    frameWidth: calculateBadgeWidth(screenWidth: UIScreen.main.bounds.width),
                                    currentDay: index + 1,
                                    isSelected: index + 1 == selectedDay
                                )
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
                    
                    ProgressGraphicsView(currentDay: selectedDay)
                        .padding(.top, 20)
                    
                    DailyMenuView(currentDay: selectedDay)
                        .frame(height: UIScreen.main.bounds.height * 0.4, alignment: .bottom)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationDestination(isPresented: selectedRecipe.isRecipeSelected) {
                VStack {
                    RecipeDetailsView()
                }
            }
        }
        .onAppear {
            networkMonitor.startMonitoring()
        }
        .onDisappear {
            networkMonitor.stopMonitoring()
        }
        .onChange(of: networkMonitor.isConnected) {
            if networkMonitor.isConnected {
                networkError = nil
                isAlertPresented = false
            } else {
                networkError = .noConnection
                isAlertPresented = true
            }
        }
        .alert(Text(networkError?.failureReason ?? ""), isPresented: $isAlertPresented) {
            Button("Ok", role: .cancel) {
                isAlertPresented = false
            }
        } message: {
            Text("\n\(networkError?.recoverySuggestion ?? "") \n\n\(networkError?.errorDescription ?? "")")
        }
        .task {
            selectedDay = menus.isEmpty ? 1 : menus.count
            scrolledId = menus.count + 1
        }
    }
}

#Preview {
    ProgressDaysView()
        .modelContainer(for: DailyMenuModel.self, inMemory: true)
}
