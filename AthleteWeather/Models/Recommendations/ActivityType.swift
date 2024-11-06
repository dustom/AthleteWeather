//
//  ActivityType.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 03.11.2024.
//

import Foundation

enum ActivityType: String, CaseIterable, Identifiable {
    case cycling, running, hiking
    var id: Self { self }
}
