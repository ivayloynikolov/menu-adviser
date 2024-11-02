//
//  DayDetailsView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 2.11.24.
//

import SwiftUI

struct DayDetailsView: View {
    
    let currentDay: Int
    
    var body: some View {
        VStack {
            Text("Current day - \(currentDay)")
            
            Text("Estimated daily calories for day - \(currentDay)")
            
            Text("Estimated weight \(String(format: "%.2f", 0)) kg.")
                .padding(.top, 5)
            
            Text("Estimated BMI \(String(format: "%.2f", 0))")
                .padding(.top, 5)
            
            Text("Graphical representation of the values")
                .padding(.top, 15)
            
            Text("Daily menu for day - \(currentDay)")
            
            Spacer()
            
            Button(action: {
                print("generate daily menu")
            }, label: {
                Text("Generate Daily Menu")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15.0)
            })
            .background(.orange, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DayDetailsView(currentDay: 1)
}
