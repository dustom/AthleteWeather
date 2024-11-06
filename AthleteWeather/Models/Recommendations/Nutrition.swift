//
//  Nutrition.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 01.11.2024.
//

import Foundation


struct Nutrition: Identifiable {
    let title: String
    let quantity: String
    let amount: String
    let image: String
    let id = UUID()
}
