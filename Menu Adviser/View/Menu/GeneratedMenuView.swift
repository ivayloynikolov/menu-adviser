//
//  GeneratedMenuView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 12.10.24.
//

import SwiftUI
import SwiftData

struct GeneratedMenuView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var dishes: [DishModel]
    
    @Binding var isMenuGenerated: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Daily Menu")
                    .font(.title)
                
                if dishes.count > 0 {
                    List(dishes) { dish in
                        NavigationLink(dish.name) {
                            DishDetailsView(dish: dish)
                        }
                    }
                    
                    HStack {
                        Button(action: {
                            do {
                                try modelContext.delete(model: DishModel.self)
                                
                                isMenuGenerated = false
                            } catch {
                                print("Failed to delete DishModel")
                            }
                        }, label: {
                            Text("Delete Daily Menu")
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20.0)
                        })
                        .background(.red, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
                    }
                    .padding(EdgeInsets(top: 10.0, leading: 30.0, bottom: 20.0, trailing: 30.0))

                } else {
                    Text("There are no generated dishes!")
                }
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    @Previewable @State var value: Bool = true
    GeneratedMenuView(isMenuGenerated: $value)
        .modelContainer(for: [DishModel.self])
}
