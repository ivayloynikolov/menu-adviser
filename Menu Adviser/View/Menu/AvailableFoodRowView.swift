//
//  AvailableFoodRowView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import SwiftUI

struct AvailableFoodRowView: View {
    @State private var isEnabled = true
    
    var food: String
    
    var body: some View {    
        HStack {
            Text(food)
                .foregroundStyle(isEnabled ? .black : .secondary)
            
            Spacer()
            
            Button(action: {
                isEnabled.toggle()
            }, label: {
                Image(systemName: isEnabled ? "checkmark" : "xmark")
                    .foregroundStyle(isEnabled ? .green : .red)
            })
        }
        .padding(EdgeInsets(top: 5.0, leading: 30.0, bottom: 5.0, trailing: 30.0))
        .background(isEnabled ? .clear : .gray.opacity(0.1))
    }
}

#Preview {
    AvailableFoodRowView(food: "Preview name")
}
