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
    
    @State private var progressWidth: Double = 0.0
    
    var progressAnimation: Animation {
            Animation
            .easeInOut(duration: 0.5)
        }
    
    func calculateEstimatedValue() -> Float {
        var estimatedValue: Float = 0.0
        let dailyValueProgress = (targetValue - initialValue) / Float(estimatedDays)
        
        estimatedValue = initialValue + (dailyValueProgress * Float(currentDay))
        
        return estimatedValue
    }
    
    func calculateProgressBarWidth(totalBarWidth: Double) -> Double {
        var progressBarWidth = 0.0
        let progressPercent = (100.0 / Double(estimatedDays)) * Double(currentDay)
        
        progressBarWidth = (totalBarWidth / 100.0) * progressPercent
        
        return progressBarWidth
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: 15.0, alignment: .leading)
                
                ZStack(alignment: .leading) {
                    Color.gray
                        .opacity(0.3)
                        .cornerRadius(25)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8 - 70.0, maxHeight: 10.0)
                    
                    Color.green
                        .opacity(0.8)
                        .cornerRadius(25)
                        .frame(width: progressWidth, height: 10.0)
                        .onChange(of: currentDay) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                progressWidth = calculateProgressBarWidth(totalBarWidth: UIScreen.main.bounds.width * 0.8 - 70.0)
                            }
                        }
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
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 15.0)
            }
        }
    }
}

#Preview {
    ProgressBarView(title: "weight", initialValue: 0.0, targetValue: 10.0, estimatedDays: 50, currentDay: 1)
}
