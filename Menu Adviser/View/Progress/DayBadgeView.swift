//
//  DayBadgeView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 1.11.24.
//

import SwiftUI

struct DayBadgeView: View {
    
    let frameWidth: CGFloat
    let dayId: Int
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            if isSelected {
                Color.green
                    .opacity(0.3)
                    .cornerRadius(25)
                
            } else {
                Color.gray
                    .opacity(0.3)
                    .cornerRadius(25)
                
            }
            
            VStack {
                Text("DAY")
                    .bold()
                    .font(.largeTitle)
                
                Text("\(dayId)")
                    .bold()
                    .font(.largeTitle)
                
                // TODO: display real daily calories
                Text("\(1850) cal.")
            }
        }
        .frame(width: frameWidth , height: 150)
    }
}

#Preview {
    DayBadgeView(frameWidth: 100, dayId: 1, isSelected: false)
}
