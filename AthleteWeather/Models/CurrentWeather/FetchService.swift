//
//  FetchService.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 19.10.2024.
//

import Foundation


struct FetchService {
    
    private enum FetchError: Error {
        case badResponse
        case invalidURL
    }
    
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    
    func fetchWeather(for location: String) async throws -> WeatherData {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    URLQueryItem(name: "q", value: location.lowercased()),
                    URLQueryItem(name: "appid", value: Constants.apiKey),
                    URLQueryItem(name: "units", value: "metric")
                ]
        
        guard let fetchURL = components.url else {
                    throw FetchError.invalidURL
                }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        let weather = try decoder.decode(WeatherData.self, from: data)
        
        return weather
    }
    
    func fetchWeatherCoordinates(latitude: Double, longitude: Double) async throws -> WeatherData {
        let lat = String(format: "%.4f", latitude)
        let lon = String(format: "%.4f", longitude)
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
                components.queryItems = [
                    URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "lon", value: lon),
                    URLQueryItem(name: "appid", value: Constants.apiKey),
                    URLQueryItem(name: "units", value: "metric")
                ]
        
        guard let fetchURL = components.url else {
                    throw FetchError.invalidURL
                }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        let weather = try decoder.decode(WeatherData.self, from: data)
        
        return weather
    }
    
}
