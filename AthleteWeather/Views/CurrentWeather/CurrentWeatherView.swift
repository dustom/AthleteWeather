//
//  CurrentWeatherView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 25.10.2024.
//

import SwiftUI

struct CurrentWeatherView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var weatherForSelection: WeatherForSelection
    @StateObject private var locationManager = LocationManager()
    @ObservedObject private var vm = CurrentWeatherViewModel()
    @ObservedObject var locationSearchService = LocationSearchService()
    
    
    @State private var typingLocation = false
    @State private var searchLocation = ""
    @State private var showSettings = false
    @State private var showAlert = false
    
    //this property is set to true, to take advantage of the weather update when coming from backroungd - when this is set to true on launch, it will automatically update weather when the app is launched
    @State private var wasSceneBackground = true
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    switch vm.status {
                    case .notStarted:
                        EmptyView()
                    case .fetching:
                        ProgressView()
                            .frame(width: geo.size.width, height: geo.size.height)
                    case .success:
                        if !typingLocation  {
                            HStack {
                                Spacer()
                                VStack {
                                    Text(vm.weatherSource.locationName)
                                        .font(.largeTitle)
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.center)
                                        .minimumScaleFactor(0.5)
                                    Text(vm.weatherSource.tempMinMax)
                                        .font(.title3)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                VStack {
                                    Image(systemName: vm.weatherSource.weatherIcon)
                                        .font(.largeTitle)
                                        .symbolEffect(.breathe)
                                    Text(vm.weatherSource.weatherDescription)
                                        .font(.title3)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .frame(height: 90)
                            .padding()
                            
                            
                            HStack {
                                ScrollView {
                                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                                        // the propertiesArray includes all weather properties like temperature, humidity etc. - the user can choose which properties they want to see on the Current Weather tab so this array has to be filtered to show only selected properties, default settings include all of them
                                        let displayProperties = vm.propertiesArray.filter {$0.info.isIncluded}
                                        ForEach(0..<displayProperties.count, id: \.self) { property in
                                            //only wind uses a different view - in addition to speed it shows direction using an arrow and shortcuts for cardinal points
                                            if displayProperties[property].name == "Wind" {
                                                WindView(windSpeed: vm.weatherSource.windSpeed, windDegree: vm.weatherSource.windDegree, width: geo.size.width/2.3)
                                            } else {
                                                WeatherPropertyView(data: displayProperties[property].data, name: displayProperties[property].name, icon: displayProperties[property].icon, width: geo.size.width/2.3)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            if locationSearchService.searchQuery != "" {
                                
                           
                            List(locationSearchService.completions, id: \.self) { completion in
                                    Button {
                                        updateWeatherSearch(for: completion.title)
                                        
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(completion.title)
                                            Text(completion.subtitle)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    case .failed(let error):
                        VStack {
                        }
                        .onAppear {
                            showAlert = true
                            print(error.localizedDescription)
                        }
                        .alert("Weather Error", isPresented: $showAlert) {
                            Button("Reload", role: .cancel) {
                                updateWeatherOnLocation()
                            }
                        } message: {
                            Text("Couldn't load current weather for the selected location.")
                        }
                    }
                }
            }
            //the cloudiness is a number between 0 and 1 and determines what part of the sky is covered with clouds given location - the background is updated based on that from clear skies (blue) to cloudy (grey)
            .background(.blue.mix(with: .gray, by: vm.weatherSource.cloudiness).opacity(0.4))
            .navigationTitle("Athlete Weather")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "slider.horizontal.3") {
                        showSettings.toggle()
                    }
                    .tint(.primary)
                    .sheet(isPresented: $showSettings) {
                        WeatherSettingsView(viewModel: vm)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Locate", systemImage: "location.magnifyingglass") {
                        updateWeatherOnLocation()
                    }
                    .tint(.primary)
                }
            }
        }
        .searchable(text: $locationSearchService.searchQuery, isPresented: $typingLocation, prompt: "Search Location" )
        .onSubmit(of: .search) {
            //set typing location to false to go back to the default state of the view without the searchbar selected
            typingLocation = false
            Task{
                await vm.getWeather(for: locationSearchService.searchQuery)
                updateSharedWeatherForSelection()
                locationSearchService.searchQuery = ""
            }
            
        }
        .onChange(of: scenePhase) {
            // update gps location only when coming from background or when launched
            if scenePhase == .active && wasSceneBackground {
                if let status = locationManager.locationStatus {
                    switch status {
                    case .notDetermined:
                        print("Location permission not determined.")
                    case .restricted, .denied:
                        //TODO: let the user know, that they didn't allow location usage
                        print("Location access is restricted or denied.")
                    case .authorizedWhenInUse, .authorizedAlways:
                        //updates weather data based on location only when the app came from background or was initially launched + the user gave permission to use their location
                        updateWeatherOnLocation()
                    default:
                        print("Unexpected status: \(status.rawValue)")
                    }
                } else {
                    print("Fetching location status...")
                }
                
                if let error = locationManager.locationError {
                    print("Error: \(error.localizedDescription)")
                }
            }
            //save the app scene state here to use it later to update the data when becoming .active again
            if scenePhase == .background{
                wasSceneBackground = true
                vm.saveUserSettings()
            }
        }
    }
    
    //a function that updates the weather based on the devices's current location
    private func updateWeatherOnLocation() {
        locationManager.startUpdatingLocation()
        Task {
            await vm.getWeatherCoordinates(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
            //sets wasSceneBackground to false becase it had to be .active to get here
            wasSceneBackground = false
            locationManager.didFinishUpdatingLocation()
            updateSharedWeatherForSelection()
        }
    }
    
    private func updateWeatherSearch(for search: String) {
        Task{
            await vm.getWeather(for: search)
            updateSharedWeatherForSelection()
            locationSearchService.searchQuery = ""
            typingLocation = false
        }
    }
    
    private func updateSharedWeatherForSelection(){
        weatherForSelection.temperature = vm.weather.main.feelsLike
        weatherForSelection.windSpeed = vm.weather.wind.speed
        weatherForSelection.isRaining = vm.weather.weather.first!.id >= 300 && vm.weather.weather.first!.id < 600
        weatherForSelection.cloudiness = vm.weather.clouds.all/100
    }
}

#Preview {
    CurrentWeatherView()
        .environmentObject(WeatherForSelection())
}
