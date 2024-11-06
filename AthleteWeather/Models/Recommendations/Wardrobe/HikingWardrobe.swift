//
//  CyclingWardrobe.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 05.11.2024.
//

import Foundation

struct HikingWardrobe: Wardrobe {
    let weatherConditions: WeatherForSelection
    
    public init(forConditions weatherConditions: WeatherForSelection) {
        self.weatherConditions = weatherConditions
    }

    private var temperature: Double { return weatherConditions.temperature ?? 0 }

    var head: Clothing? {
        switch temperature {
        case ..<5:    return Clothing(title: "Head", description: "Warm Hat", image: "winter_cap")
        case 5..<10:  return Clothing(title: "Head", description: "Beanie", image: "light_cap" )
        case 10..<15: return Clothing(title: "Head", description: "Headband", image: "headband"  )
        default:      return Clothing(title: "Head", description: "Cap", image: "cap")
        }
    }

    var baseLayer: Clothing? {
        switch temperature {
        case ..<10:   return Clothing(title: "Base Layer", description: "Thermal Base Layer", image: "thermal_base")
        case 10..<20: return Clothing(title: "Base Layer", description: "Light Base Layer",   image: "light_base"  )
        default:      return Clothing(title: "Base Layer", description: "Moisture-Wicking Shirt", image: "tshirt" )
        }
    }

    var midLayer: Clothing? {
        switch temperature {
        case ..<10:   return Clothing(title: "Mid Layer", description: "Fleece Jacket", image: "fleece_jacket")
        case 10..<15: return Clothing(title: "Mid Layer", description: "Light Sweater", image: "light_sweater")
        default:      return nil
        }
    }

    var legs: Clothing {
        switch temperature {
        case ..<10:   return Clothing(title: "Legs", description: "Warm Pants", image: "insulated_pants")
        case 10..<16: return Clothing(title: "Legs", description: "Pants", image: "long_pants"   )
        default:      return Clothing(title: "Legs", description: "Shorts", image: "shorts"  )
        }
    }

    var hands: Clothing? {
        switch temperature {
        case ..<5:   return Clothing(title: "Hands", description: "Winter Gloves", image: "insulated_gloves")
        case 5..<10: return Clothing(title: "Hands", description: "Light Gloves",  image: "long_gloves" )
        default:     return nil
        }
    }
    
    var feet: Clothing {
        switch temperature {
        case ..<3:   return Clothing(title: "Feet", description: "Insulated Boots", image: "winter_shoes")
        case 3..<10: return Clothing(title: "Feet", description: "Hiking Boots", image: "hiking_boots")
        default:     return Clothing(title: "Feet", description: "Hiking Shoes", image: "hiking_shoes")
        }
    }

    var shell: Clothing? {
        switch temperature {
        case ..<5:   return Clothing(title: "Shell", description: "Warm Jacket", image: "heavy_jacket")
        case 5..<15: return Clothing(title: "Shell", description: "Light Jacket", image: "windproof_jacket" )
        default:     return nil
        }
    }

    var windProtection: Clothing? {
        if weatherConditions.windSpeed ?? 0 > 5 {
            return Clothing(title: "Wind Protection", description: "Windproof Layer", image: "windproof")
        } else {
            return nil
        }
    }
    
    var rainProtection: Clothing? {
        if weatherConditions.isRaining ?? false {
            return Clothing(title: "Rain Protection", description: "Waterproof Layer", image: "raincoat")
        } else {
            return nil
        }
    }
}
