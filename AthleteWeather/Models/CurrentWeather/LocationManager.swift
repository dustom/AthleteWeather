//
//  LocationManager.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 20.10.2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var location: CLLocation? // Publish user location updates
    @Published var locationStatus: CLAuthorizationStatus? // To track authorization status
    @Published var locationError: Error? // Handle any location errors

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // Request permission
        locationManager.startUpdatingLocation() // Start updating location
    }

    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        self.location = newLocation
    }

    // Handle authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationStatus = manager.authorizationStatus
    }

    // Handle errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError = error
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func didFinishUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}
