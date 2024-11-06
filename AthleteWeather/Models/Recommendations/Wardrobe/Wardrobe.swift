//
//  Wardrobe.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 05.11.2024.
//

import Foundation


protocol Wardrobe {
    
    var head: Clothing? { get }
    var baseLayer: Clothing? { get }
    var midLayer: Clothing? { get }
    var legs: Clothing { get }
    var hands: Clothing? { get }
    var feet: Clothing { get }
    var shell: Clothing? { get }
    var windProtection: Clothing? { get }
    var rainProtection: Clothing? { get }
}

extension Wardrobe {
    func recommendClothing() -> [Clothing] {
        return [head, baseLayer, midLayer, legs, hands, feet, shell, windProtection, rainProtection].compactMap { $0 }
    }
}


