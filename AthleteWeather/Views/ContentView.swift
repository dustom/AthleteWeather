import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CurrentWeatherView()
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Current Weather", systemImage: "cloud.sun")
                        .foregroundStyle(.primary)
                }
            RecommendationsView()
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Recommendations", systemImage: "tshirt")
                }
        }
        .tint(.primary)
    }
}

#Preview {
    ContentView()
        .environmentObject(WeatherForSelection())
}
