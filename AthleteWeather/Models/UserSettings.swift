//
//  UserSettings.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 25.10.2024.
//

import Foundation
import SwiftData

@Model
class UserSettings {
    
    @Attribute(.unique) var name: String
    var info: WeatherPropertyInfo
    
    init(name: String, info: WeatherPropertyInfo) {
        self.name = name
        self.info = info
    }
    
}
