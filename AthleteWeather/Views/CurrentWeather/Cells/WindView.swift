//
//  WindView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 20.10.2024.
//

import SwiftUI



struct WindView: View {
    
    private let directions = [
        "N",  // North
        "NNE", // North-Northeast
        "NE",  // Northeast
        "ENE", // East-Northeast
        "E",   // East
        "ESE", // East-Southeast
        "SE",  // Southeast
        "SSE", // South-Southeast
        "S",   // South
        "SSW", // South-Southwest
        "SW",  // Southwest
        "WSW", // West-Southwest
        "W",   // West
        "WNW", // West-Northwest
        "NW",  // Northwest
        "NNW"  // North-Northwest
    ]
    
    let windSpeed: String
    let windDegree: Double
    let width: CGFloat
    var body: some View {
        VStack {
            HStack {
                Text("Wind")
                Spacer()
                Text(getDirection(from: windDegree))
                Image(systemName: "arrow.up")
                    .rotationEffect(.degrees(windDegree))
                    .symbolEffect(.wiggle)
                
            }
            .foregroundStyle(.secondary)
            .padding([.leading, .top, .trailing], 15)
            .padding(.bottom)
            Text(windSpeed)
                .font(.largeTitle)
            Spacer()
        }
        .frame(width: width, height: 150)
        .background(.ultraThickMaterial)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 2, x:0, y: 2)
        .padding(3)
    }
    
    
    func getDirection(from degrees: Double) -> String {
        let index = Int((degrees + 11.25) / 22.5) % 16
        return directions[index]
    }
}

#Preview {
    WindView(windSpeed: "10 m/s", windDegree: 150, width: 175)
}
