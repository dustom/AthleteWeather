//
//  CyclingWardrobe.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 05.11.2024.
//

import Foundation

struct CyclingWardrobe: Wardrobe {
    let weatherConditions: WeatherForSelection
    
    public init(forConditions weatherConditions: WeatherForSelection) {
        self.weatherConditions = weatherConditions
    }

    private var temperature: Double { return weatherConditions.temperature ?? 0 }

    var head: Clothing? {
        switch temperature {
        case ..<5:    return Clothing(title: "Head", description: "Winter Cap",    image: "winter_cap")
        case 5..<10:  return Clothing(title: "Head", description: "Skullcap",      image: "light_cap" )
        case 10..<15: return Clothing(title: "Head", description: "Headband",      image: "headband"  )
        default:      return nil
        }
    }
    var baseLayer: Clothing? {
        switch temperature {
        case ..<10:   return Clothing(title: "Base Layer", description: "Thermal",       image: "thermal_base")
        case 10..<20: return Clothing(title: "Base Layer", description: "Light",         image: "light_base"  )
        default:      return nil
        }
    }

    var midLayer: Clothing? {
        switch temperature {
        case ..<10:   return Clothing(title: "Mid layer", description: "Thermal Jersey", image: "thermal_jersey")
        case 10..<20: return Clothing(title: "Mid layer", description: "Long Sleeved Jersey", image: "long_jersey")
        default:      return Clothing(title: "Mid layer", description: "Jersey", image: "jersey")
        }
    }

    var legs: Clothing {
        switch temperature {
        case ..<10:   return Clothing(title: "Legs", description: "Thermal Bibs", image: "thermal_bibs")
        case 10..<18: return Clothing(title: "Legs", description: "Long Bibs",    image: "long_bibs"   )
        default:      return Clothing(title: "Legs", description: "Bib Shorts",   image: "bib_shorts"  )
        }
    }

    var hands: Clothing? {
        switch temperature {
        case ..<10:   return Clothing(title: "Hands", description: "Insulated Gloves", image: "insulated_gloves")
        case 10..<15: return Clothing(title: "Hands", description: "Long Gloves",      image: "long_gloves"     )
        default:      return Clothing(title: "Hands", description: "Summer Gloves",    image: "gloves"          )
        }
    }
    
    var feet: Clothing {
        switch temperature {
        case ..<3:   return Clothing(title: "Feet", description: "Winter Shoes",      image: "winter_shoes")
        case 3..<7:  return Clothing(title: "Feet", description: "Shoe Covers" ,      image: "covers"      )
        case 7..<15: return Clothing(title: "Feet", description: "Warm Socks Covers", image: "warm_socks"  )
        default:     return Clothing(title: "Feet", description: "Light Socks",       image: "socks"       )
        }
    }

    var shell: Clothing? {
        switch temperature {
        case ..<5:   return Clothing(title: "Shell", description: "Insulated Jacket", image: "insulated_jacket")
        case 5..<15: return Clothing(title: "Shell", description: "Light Jacket",     image: "light_jacket"    )
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
