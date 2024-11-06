//
//  CyclingWardrobe.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 05.11.2024.
//

import Foundation

struct RunningWardrobe: Wardrobe {
    let weatherConditions: WeatherForSelection
    
    public init(forConditions weatherConditions: WeatherForSelection) {
        self.weatherConditions = weatherConditions
    }

    private var temperature: Double { return weatherConditions.temperature ?? 0 }

    var head: Clothing? {
        switch temperature {
        case ..<5:    return Clothing(title: "Head", description: "Warm Cap", image: "winter_cap")
        case 5..<10:  return Clothing(title: "Head", description: "Beanie", image: "light_cap")
        case 10..<20: return Clothing(title: "Head", description: "Headband",image: "headband")
        default:      return Clothing(title: "Head", description: "Cap or Visor", image: "cap")
        }
    }

    var baseLayer: Clothing? {
        switch temperature {
        case ..<10:   return Clothing(title: "Base Layer", description: "Warm Base Layer", image: "thermal_base")
        case 10..<20: return Clothing(title: "Base Layer", description: "Light Base Layer", image: "long_sleeve")
        default:      return Clothing(title: "Base Layer", description: "Breathable T-Shirt", image: "tshirt")
        }
    }

    var midLayer: Clothing? {
        switch temperature {
        case ..<5:    return Clothing(title: "Mid Layer", description: "Warm Sweater", image: "hoodie")
        case 5..<10:  return Clothing(title: "Mid Layer", description: "Light Sweater", image: "long_jersey")
        default:      return nil
        }
    }

    var legs: Clothing {
        switch temperature {
        case ..<5:   return Clothing(title: "Legs", description: "Warm Tights", image: "thermal_bibs")
        case 5..<15: return Clothing(title: "Legs", description: "Tights", image: "long_bibs")
        default:     return Clothing(title: "Legs", description: "Shorts", image: "shorts")
        }
    }

    var hands: Clothing? {
        switch temperature {
        case ..<5:   return Clothing(title: "Hands", description: "Warm Gloves", image: "insulated_gloves")
        case 5..<10: return Clothing(title: "Hands", description: "Light Gloves", image: "long_gloves")
        default:     return nil
        }
    }
    
    var feet: Clothing {
        switch temperature {
        case ..<8:   return Clothing(title: "Feet", description: "Warm Socks", image: "warm_socks")
        default:     return Clothing(title: "Feet", description: "Light Socks",   image: "socks")
        }
    }

    var shell: Clothing? {
        switch temperature {
        case ..<5:   return Clothing(title: "Shell", description: "Warm Jacket", image: "windproof_jacket")
        case 5..<15: return Clothing(title: "Shell", description: "Light Jacket",     image: "light_jacket")
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
