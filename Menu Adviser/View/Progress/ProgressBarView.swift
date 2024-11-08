//
//  ProgressBarView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 4.11.24.
//

import SwiftUI

struct ProgressBarView: View {
    
    let title: String
    let initialValue: Float
    let targetValue: Float
    let estimatedDays: Int
    let currentDay: Int
    
    func calculateEstimatedValue() -> Float {
        var estimatedValue: Float = 0.0
        let dailyValueProgress = (targetValue - initialValue) / Float(estimatedDays)
        
        estimatedValue = initialValue + (dailyValueProgress * Float(currentDay))
        
        return estimatedValue
    }
    
    func calculateProgressBarWidth(totalBarWidth: Double) -> Double {
        var progressBarWidth = 0.0
        let progressPercent = (Double(estimatedDays) / 100.0) * Double(currentDay)
        
        progressBarWidth = (totalBarWidth / 100.0) * progressPercent
        
        return progressBarWidth
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text(title)
                        .frame(width: geometry.size.width * 0.2, height: 15.0, alignment: .leading)
                    
                    ZStack(alignment: .leading) {
                        Color.gray
                            .opacity(0.3)
                            .cornerRadius(25)
                            .frame(maxWidth: .infinity, maxHeight: 10.0)
                        
                        Color.green
                            .opacity(0.8)
                            .cornerRadius(25)
                            .frame(width: calculateProgressBarWidth(totalBarWidth: geometry.size.width), height: 10.0)
                    }
                }
                
                HStack {
                    Spacer()
                    
                    HStack {
                        Text(String(format: "%.2f", initialValue))
                            .font(.caption)
                            .frame(height: 15.0, alignment: .leading)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f", calculateEstimatedValue()))
                            .font(.caption)
                            .frame(height: 15.0, alignment: .center)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f", targetValue))
                            .font(.caption)
                            .frame(height: 15.0, alignment: .trailing)
                    }
                    .frame(width: geometry.size.width * 0.8, height: 15.0)
                }
            }
        }
    }
}

#Preview {
    ProgressBarView(title: "weight", initialValue: 0.0, targetValue: 10.0, estimatedDays: 50, currentDay: 1)
}
