//
//  RecommendationItemView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 31.10.2024.
//

import SwiftUI

struct NutritionItemView: View {
    let nutritionItem: Nutrition
    
    var body: some View {
                VStack{
                    HStack{
                        Text(nutritionItem.title)
                            .font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text(nutritionItem.quantity)
                            .font(.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Image(nutritionItem.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                    Spacer()
                    Text(nutritionItem.amount)
                        .font(.subheadline)
                }
                .padding()
                .frame(width: 135, height: 160)
                .background(.ultraThickMaterial.opacity(0.8))
                .clipShape(.rect(cornerRadius: 15))
            }
}

#Preview {
    NutritionItemView(nutritionItem: Nutrition(title: "Food", quantity: "10×", amount: "250g", image: "waterBottle"))
}
