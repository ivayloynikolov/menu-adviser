//
//  AvailableFoodRowView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import SwiftUI

struct AllergenRowView: View {
    @State private var isEnabled = true
    
    @Binding var allergen: AllergenData
    
    var body: some View {    
        HStack {
            Text(allergen.name)
                .foregroundStyle(allergen.isSelected ? .primary : .secondary)
            
            Spacer()
            
            Button(action: {
                allergen.isSelected.toggle()
            }, label: {
                Image(systemName: allergen.isSelected ? "checkmark" : "xmark")
                    .foregroundStyle(allergen.isSelected ? .green : .red)
            })
        }
        .padding(EdgeInsets(top: 5.0, leading: 30.0, bottom: 5.0, trailing: 30.0))
        .background(isEnabled ? .clear : .gray.opacity(0.1))
    }
}

#Preview {
    @Previewable @State var value = AllergenData(id: 0, name: "test", isSelected: false)
    AllergenRowView(allergen: $value)
}
