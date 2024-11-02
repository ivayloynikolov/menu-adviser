//
//  HomeView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI

struct ProgressView: View {
    
    @State private var selectedDay: Int = 1
    @State private var scrolledId: Int?
    
    let scrollViewPadding: CGFloat = 20.0
    let spacingBetweenDayBadges: CGFloat = 20.0
    
    let days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    
    func calculateBadgeWidth(screenWidth: CGFloat) -> CGFloat {
        var result = screenWidth - scrollViewPadding * 2
        result -= spacingBetweenDayBadges * 2
        result /= 3
        
        return result
    }
        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Progress")
                    .font(.title)
            
                ScrollView(.horizontal) {
                    LazyHStack(spacing: spacingBetweenDayBadges) {
                        ForEach(days, id: \.self) { index in
                            DayBadgeView(frameWidth: calculateBadgeWidth(screenWidth: geometry.size.width), dayId: index, isSelected: index == selectedDay)
                                .id(index)
                                .onTapGesture {
                                    selectedDay = index
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
                    .padding(.top, 40)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    ProgressView()
}
