//
//  RecommendationsViewModel.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 01.11.2024.
//

import Foundation
import SwiftUI

class RecommendationsViewModel: ObservableObject {
    
    @Published var nutrition: [Nutrition] = []
    @Published var clothing: [Clothing] = []
    
    private var temperature: Double = 0
    
    func recommendNutrition(for duration: Double){
        
        let fluidsQuantity = Int(ceil(duration))
        let fluidsAmount = Double(duration * 500)
        let fluidsAmountString = fluidsAmount > 1000 ? "\(String(format: "%.1f", (fluidsAmount / 1000))) l" : "\(String(format: "%.0f", fluidsAmount)) ml"
        let carbsQuantity = Int(ceil(duration * 2))
        let carbsAmount = Double(duration * 60)
        let carbsAmountString = carbsAmount > 1000 ? "\(String(format: "%.1f", (carbsAmount / 1000))) kg" : "\(String(format: "%.0f", carbsAmount)) g"
        
        nutrition = [
            Nutrition(title: "Fluids", quantity: "\(fluidsQuantity)×", amount: fluidsAmountString, image: "waterBottle"),
            Nutrition(title: "Carbs", quantity: "\(carbsQuantity)×", amount: carbsAmountString, image: "banana")
        ]
        
        //Add 1 caffein energy gel every hour when the activity is longer than 2 hours, but at max 4 of them
        let caffeineQuantity = Int((duration - 1) * 1)
        if duration > 2 && duration <= 5 {
            nutrition.append(Nutrition(title: "Caffeine", quantity: "\(caffeineQuantity)×", amount: "\(caffeineQuantity) \(caffeineQuantity < 2 ? "pack" : "packs")", image: "energyGel"))
        } else if duration > 5 {
            nutrition.append(Nutrition(title: "Caffeine", quantity: "4×", amount: "4 packs", image: "energyGel"))
        }
        
        if temperature > 25 {
            nutrition.append(Nutrition(title: "Magnesium", quantity: "1×", amount: "Daily Dose", image: "magnesium"))
        }
        
    }
    
    
    
    func recommendClothing(for conditions: WeatherForSelection, type: ActivityType){
        temperature = conditions.temperature ?? 0
        clothing = chooseWardrobe(activity: type, conditions: conditions).recommendClothing()
    }

    
    func chooseWardrobe(activity: ActivityType, conditions: WeatherForSelection) -> any Wardrobe {
            switch activity {
            case .cycling:
                return CyclingWardrobe(forConditions: conditions)
            case .running:
                // Example TODO: Create a WalkingWardrobe that conforms to Wardrobe
                return RunningWardrobe(forConditions: conditions)
            case .hiking:
                return HikingWardrobe(forConditions: conditions)
            }
        }
    
}
