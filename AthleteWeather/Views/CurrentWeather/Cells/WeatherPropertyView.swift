//
//  WindView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 20.10.2024.
//

import SwiftUI

struct WeatherPropertyView: View {
    let data: String
    let name: String
    let icon: String
    let width: CGFloat
    var body: some View {
            VStack{
                HStack {
                    Text(name)
                    Spacer()
                    Image(systemName: icon)
                }
                .foregroundStyle(.secondary)
                .padding([.leading, .top, .trailing], 15)
                .padding(.bottom)
                Text(data)
                    .font(.largeTitle)
                Spacer()
            }
            .frame(width: width, height: 150)
            .background(.ultraThickMaterial)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(radius: 2, x:0, y: 2)
            .padding(3)
    }
}

#Preview {
    WeatherPropertyView(data: "10 m/s", name: "Wind", icon: "wind", width: 175)
}
