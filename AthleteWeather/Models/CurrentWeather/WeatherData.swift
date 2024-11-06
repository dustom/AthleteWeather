//
//  Untitled.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 19.10.2024.
//


import Foundation

// Top-level response struct
struct WeatherData: Codable {
    let weather: [Weather]
    let main: MainWeather
    let visibility: Double
    let wind: Wind
    let clouds: Clouds
    let sys: System
    let name: String
}

// Weather condition struct (array)
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

// Main weather data struct
struct MainWeather: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    let feelsLike: Double
    let seaLevel: Double
    let grndLevel: Double
    
    
    //     Custom coding keys to map JSON keys with underscores
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel  = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// Wind data struct
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Double
}

// System data struct
struct System: Codable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

