//
//  LocationManager.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var hasLocationAccess: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationAccess() {
        print("DEBUG: Requesting location access")
        manager.requestWhenInUseAuthorization()
    }
    
    func startFetchingCurrentLocation() {
        print("DEBUG: Starting location updates")
        manager.startUpdatingLocation()
    }
    
    func stopFetchingCurrentLocation() {
        print("DEBUG: Stopping location updates")
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch location: \(error.localizedDescription)")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("DEBUG: Not determined")
            hasLocationAccess = false
        case .restricted, .denied:
            print("DEBUG: Restricted/Denied")
            hasLocationAccess = false
        case .authorizedAlways, .authorizedWhenInUse:
            print("DEBUG: Authorized")
            hasLocationAccess = true
            startFetchingCurrentLocation()
        @unknown default:
            print("DEBUG: Unknown default")
            hasLocationAccess = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("DEBUG: New location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        self.userLocation = location
    }
}
