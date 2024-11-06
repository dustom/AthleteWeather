import Foundation
import SwiftData

@MainActor
class CurrentWeatherViewModel: ObservableObject {
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var status: FetchStatus = .notStarted
    private let fetcher = FetchService()
    let container = try? ModelContainer(for: UserSettings.self)
        
    @Published var weather: WeatherData
    @Published var weatherSource: WeatherModel
    @Published var propertiesArray: [WeatherProperty] = []
    var userSettings: [UserSettings]?
    
    
    init() {
        let decoder = JSONDecoder()
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "realtime", withExtension: "json")!)
        weather = try! decoder.decode(WeatherData.self, from: data)
        weatherSource = WeatherModel()
        
        // userSettings will be pulled from the SwiftData = if there is nothing there, it will use optional binding down there ie. default settings
        if let context = container?.mainContext {
            let fetchDescriptor = FetchDescriptor<UserSettings>()
            do {
                userSettings = try context.fetch(fetchDescriptor)
            } catch {
                print("Failed to fetch user settings:", error)
                userSettings = [] // Set as empty array if fetch fails
            }
        }
        
        // Initialize propertiesArray with the default values
        propertiesArray = [
            WeatherProperty(data: "",
                            name: Constants.WeatherPropertyNames.temperature,
                            icon: "thermometer.medium",
                            info: userSettings?.first(where: { $0.name == Constants.WeatherPropertyNames.temperature })?.info ?? WeatherPropertyInfo(id: 1, isIncluded: true)),
            
            WeatherProperty(data: "",
                            name: Constants.WeatherPropertyNames.feelsLike,
                            icon: "thermometer.variable.and.figure",
                            info: userSettings?.first(where: { $0.name == Constants.WeatherPropertyNames.feelsLike })?.info ?? WeatherPropertyInfo(id: 2, isIncluded: true)),
            
            WeatherProperty(data: "",
                            name: Constants.WeatherPropertyNames.wind,
                            icon: "",
                            info: userSettings?.first(where: { $0.name == Constants.WeatherPropertyNames.wind })?.info ??  WeatherPropertyInfo(id: 3, isIncluded: true)),
            
            WeatherProperty(data: "",
                            name: Constants.WeatherPropertyNames.visibility,
                            icon: "eye",
                            info: userSettings?.first(where: { $0.name == Constants.WeatherPropertyNames.visibility })?.info ?? WeatherPropertyInfo(id: 4, isIncluded: true)),
            
            WeatherProperty(data: "",
                            name: Constants.WeatherPropertyNames.humidity,
                            icon: "humidity.fill",
                            info: userSettings?.first(where: { $0.name == Constants.WeatherPropertyNames.humidity })?.info ??  WeatherPropertyInfo(id: 5, isIncluded: true)),
            
            WeatherProperty(data: "",
                            name: Constants.WeatherPropertyNames.pressure,
                            icon: "barometer",
                            info: userSettings?.first(where: { $0.name == Constants.WeatherPropertyNames.pressure })?.info ?? WeatherPropertyInfo(id: 6, isIncluded: true)),
            
            WeatherProperty(data: "",
                            name: Constants.WeatherPropertyNames.sunrise,
                            icon: "sunrise.fill",
                            info: userSettings?.first(where: { $0.name == Constants.WeatherPropertyNames.sunrise })?.info ?? WeatherPropertyInfo(id: 7, isIncluded: true)),
            
            WeatherProperty(data: "",
                            name: Constants.WeatherPropertyNames.sunset,
                            icon: "sunset.fill",
                            info: userSettings?.first(where: { $0.name == Constants.WeatherPropertyNames.sunset })?.info ?? WeatherPropertyInfo(id: 8, isIncluded: true)),
        ]
    }
    
    
    
    func getWeather(for location: String) async {
        status = .fetching
        
        do {
            weather = try await fetcher.fetchWeather(for: location)
            //after fetching data from an API, it converts them to a format usable in CurrentWeatherView
            createWeatherSource(from: weather)
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getWeatherCoordinates(latitude: Double, longitude: Double) async {
        status = .fetching
        
        do {
            weather = try await fetcher.fetchWeatherCoordinates(latitude: latitude, longitude: longitude)
            //after fetching data from an API, it converts them to a format usable in CurrentWeatherView
            createWeatherSource(from: weather)
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
    
    func saveUserSettings() {
        
        let context = container?.mainContext
        for i in 0..<propertiesArray.count {
            
            //this line saves the correct sorting made by user - the list in UI uses a generated UUID, but the specific Int is needed to actually sort the array on the next start. The array is already sorted from the list, so I just use this to copy this sorting
            propertiesArray[i].info.id = i
            
            let userSetting = UserSettings(name: propertiesArray[i].name, info: propertiesArray[i].info)
            context?.insert(userSetting)
        }
        do {
            try context?.save()
        } catch {
            print("Failed to save user settings:", error)
        }
    }
    
    
    //simple formatting of the raw JSON data to usable data
    private func createWeatherSource(from weather: WeatherData) {
        weatherSource.weatherDescription = weather.weather.first?.description.capitalized ?? "No description."
        weatherSource.temperature = (String(format: "%.0f", weather.main.temp.rounded())) + "°C"
        weatherSource.cloudiness = weather.clouds.all / 100
        weatherSource.visibility = (String(format: "%.0f", weather.visibility / 1000)) + " km"
        weatherSource.windSpeed = ("\(weather.wind.speed) m/s")
        weatherSource.windDegree = Double(weather.wind.deg)
        weatherSource.humidity = (String(format: "%.0f", weather.main.humidity)) + "%"
        weatherSource.pressure = ("\(weather.main.pressure) hPa")
        weatherSource.locationName = weather.name
        weatherSource.weatherIcon = {
            switch weather.weather.first!.id {
            case 200...232:
                return "cloud.bolt.fill"
            case 300...321:
                return "cloud.drizzle.fill"
            case 500...531:
                return "cloud.rain.fill"
            case 600...622:
                return "cloud.snow.fill"
            case 701...781:
                return "cloud.fog.fill"
            case 800:
                return "sun.max.fill"
            case 801...804:
                return "cloud.fill"
            default:
                return "cloud.fill"
            }
        }()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        weatherSource.sunrise = dateFormatter.string(from: Date(timeIntervalSince1970: weather.sys.sunrise))
        weatherSource.sunset = dateFormatter.string(from: Date(timeIntervalSince1970: weather.sys.sunset))
        weatherSource.tempFeelsLike = (String(format: "%.0f", weather.main.feelsLike.rounded())) + "°C"
        weatherSource.tempMin = (String(format: "%.0f", weather.main.tempMin.rounded())) + "°C"
        weatherSource.tempMax = (String(format: "%.0f", weather.main.tempMax.rounded())) + "°C"
        weatherSource.tempMinMax = ("↓\(weatherSource.tempMin) ↑\(weatherSource.tempMax)")
    
        //when all data is formatted, it is used to fill an array where all data needed to display weather properties on CurrentWeather is stored
        fillWeatherProperties()
    }
    
    private func fillWeatherProperties() {
        // Update the propertiesArray using both weatherSource data and userSettingsDictionary
        
        for index in propertiesArray.indices {
            let propertyName = propertiesArray[index].name
            
            // Update data based on property name
            switch propertyName {
            case Constants.WeatherPropertyNames.temperature:
                propertiesArray[index].data = weatherSource.temperature
            case Constants.WeatherPropertyNames.feelsLike:
                propertiesArray[index].data = weatherSource.tempFeelsLike
            case Constants.WeatherPropertyNames.wind:
                propertiesArray[index].data = weatherSource.windSpeed
            case Constants.WeatherPropertyNames.visibility:
                propertiesArray[index].data = weatherSource.visibility
            case Constants.WeatherPropertyNames.humidity:
                propertiesArray[index].data = weatherSource.humidity
            case Constants.WeatherPropertyNames.pressure:
                propertiesArray[index].data = weatherSource.pressure
            case Constants.WeatherPropertyNames.sunrise:
                propertiesArray[index].data = weatherSource.sunrise
            case Constants.WeatherPropertyNames.sunset:
                propertiesArray[index].data = weatherSource.sunset
            default:
                break
            }
        }
        
        // this line just sorts the array based on the userSettings or default data -
        propertiesArray.sort(by: { $0.info.id < $1.info.id })
    }
    
    
}
