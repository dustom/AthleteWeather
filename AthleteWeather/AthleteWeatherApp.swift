//
//  AthleteWeatherApp.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 19.10.2024.
//

import SwiftUI
import CoreLocation
import SwiftData

@main
struct AthleteWeatherApp: App {
    @StateObject var weatherForSelection = WeatherForSelection()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherForSelection)
        }
    }
}
