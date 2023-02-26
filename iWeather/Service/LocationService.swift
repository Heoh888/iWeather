//
//  LocationService.swift
//  iWeather
//
//  Created by Алексей Ходаков on 21.02.2023.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject {
    
    override init() {
        super.init()
        configureLocationManager()
    }
    
    let locationManager = CLLocationManager()
    var location = PassthroughSubject<CLLocation, Never>()
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location.send(location)
    }
}
