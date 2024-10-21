//
//  DishDetailsView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 13.10.24.
//

import SwiftUI

struct DishDetailsView: View {
    let dish: DishModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text(dish.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    Text(dish.details)
                        .padding(.bottom, 30)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Type")
                                .font(.title)
                            
                            Text(dish.type)
                                .padding(.bottom, 10)
                            
                            Text("Yields")
                                .font(.title)
                            
                            ForEach(Array(dish.yields.enumerated()), id: \.0) { index, yield in
                                Text(yield)
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            AsyncImage(url: URL(string: dish.image)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .clipShape(.rect(cornerRadius: 25))
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Directions")
                        .font(.title)
                        .padding(.top, 30)
                    
                    ForEach(Array(dish.directions.enumerated()), id: \.0) { index, direction in
                        Text("\(index + 1). \(direction)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Macros")
                        .font(.title)
                        .padding(.top, 20)
                    
                    HStack {
                        Text("\(dish.calories)")
                        
                        Text("\(dish.macros["fat"] ?? 0)")
                    }
                    
                    Text("Serving size")
                        .font(.title)
                        .padding(.top, 20)
                    
                    Text(dish.servingSize)
                }
            }
        }
    }
}

#Preview {
    DishDetailsView(dish: DishModel(name: "Name", details: "Details", type: "Type", image: "imageUrl", yields: ["Yields"], ingredients: ["Ingredients"], directions: ["Directions"], macros: ["fat" : 33], calories: 33, servingSize: "1 portion"))
}
