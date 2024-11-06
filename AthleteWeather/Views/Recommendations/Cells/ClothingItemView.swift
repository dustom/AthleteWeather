//
//  RecommendationItemView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 31.10.2024.
//

import SwiftUI

struct ClothingItemView: View {
    let clothingItem: Clothing
    
   
    var body: some View {
        VStack{
            HStack{
                Text(clothingItem.title)
                    .font(.subheadline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            Spacer()
            Image(clothingItem.image)
                .resizable()
                .scaledToFit()
                .frame(height: 60)

            Spacer()
            Text(clothingItem.description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding()
        .frame(width: 135, height: 160)
        .background(.ultraThickMaterial.opacity(0.8))
        .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview {
    ClothingItemView(clothingItem: Clothing(title: "Torso", description: "Winter Jacket", image: "winterJacket"))
}
