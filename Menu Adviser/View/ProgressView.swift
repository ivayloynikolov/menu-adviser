//
//  HomeView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 6.10.24.
//

import SwiftUI

struct ProgressView: View {
        
    var body: some View {
        VStack {
            Text("Progress")
                .font(.title)
        
            // TODO: replace the content with a dynamic data
            Text("Estimated days scroll view")
                .padding(.top, 20)
                .fontWeight(.bold)
        
            Text("Daily calories consumption")
                .padding(.top, 50)
            
            Text("Estimated weight \(String(format: "%.2f", 0)) kg.")
                .padding(.top, 5)
            
            Text("Estimated BMI \(String(format: "%.2f", 0))")
                .padding(.top, 5)
            
            Text("Graphical representation of the values")
                .padding(.top, 15)
        }
        .padding(.top, 20)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ProgressView()
}
