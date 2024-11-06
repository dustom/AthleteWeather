//
//  WeatherProperty.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 22.10.2024.
//

import Foundation

struct WeatherProperty: Identifiable {
    let id = UUID()
    var data: String
    let name: String
    let icon: String
    var info: WeatherPropertyInfo
}
