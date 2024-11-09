//
//  Untitled.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 19.10.2024.
//


import Foundation


import Foundation

struct CurrentWeatherData: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tzId: String
    
    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzId = "tz_id"
    }
}

struct CurrentWeather: Codable {
    let tempC: Double
    let isDay: Int
    let condition: Condition
    let windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMb: Double
    let pressureIn: Double
    let precipMm: Double
    let humidity: Int
    let cloud: Double
    let feelslikeC: Double
    let visKm: Double
    let uv: Double
    let gustKph: Double
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case visKm = "vis_km"
        case uv
        case gustKph = "gust_kph"
    }
}

struct Condition: Codable {
    let text: String
    let code: Int
}

